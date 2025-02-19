defmodule Bookings.Workers.CSVFetcher do
  @moduledoc """
  Fetches the CSV file from the Phoenix static directory at scheduled intervals.
  """

  use GenServer

  import Bookings.Workers.CSVFetcher.Helpers

  require Logger

  alias Bookings.Adapters.Airbnb
  alias Bookings.Cache.RoomsETS
  alias NimbleCSV.RFC4180, as: CSVParser

  @retry_interval :timer.minutes(5)
  @max_retries 3

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec fetch_csv() :: :ok
  def fetch_csv do
    GenServer.cast(__MODULE__, :fetch_csv)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    Process.send_after(self(), :fetch_csv, 1_000)
    {:ok, state}
  end

  @impl true
  def handle_cast(:fetch_csv, state) do
    RoomsETS.initialize_data()
    attempt_fetch(0)
    {:noreply, state}
  end

  @impl true
  def handle_info(:fetch_csv, state) do
    RoomsETS.create_table()
    attempt_fetch(0)
    {:noreply, state}
  end

  @impl true
  def handle_info({:retry_fetch, retries}, state) do
    attempt_fetch(retries)
    {:noreply, state}
  end

  @impl true
  def handle_info({:process_csv, file_path}, state) do
    process_csv(file_path)
    {:noreply, state}
  end

  # Private functions

  defp attempt_fetch(retries) when retries < @max_retries do
    case Airbnb.get(:csv) do
      {:ok, data} ->
        file_path = csv_path()
        File.write!(file_path, data)
        Process.send_after(self(), {:process_csv, file_path}, 1_000)

      {:error, reason} ->
        Logger.warning(
          "Error fetching CSV: #{inspect(reason)}, retrying in #{@retry_interval} (#{retries + 1}/#{@max_retries})..."
        )

        schedule_retry(retries + 1)
    end
  end

  defp attempt_fetch(_retries) do
    Logger.error("Maximum retries reached. Stopping fetch.")
  end

  defp schedule_retry(retries) do
    Process.send_after(self(), {:retry_fetch, retries}, @retry_interval)
  end

  defp process_csv(file_path) do
    _ =
      file_path
      |> File.stream!()
      |> Stream.drop(1)
      |> CSVParser.parse_stream(skip_headers: false)
      |> Flow.from_enumerable()
      |> Flow.partition(max_demand: 100, stages: 4)
      |> Flow.map(&cast_row_to_changeset/1)
      |> Flow.filter(&validate_changeset/1)
      |> Flow.reduce(fn -> [] end, fn changeset, acc -> [normalize_room(changeset) | acc] end)
      |> Flow.on_trigger(fn batch, _state ->
        RoomsETS.insert_batch(batch)
        {batch, nil}
      end)
      |> Enum.to_list()

    File.rm(file_path)

    :ok
  end
end
