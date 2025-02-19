defmodule Bookings.Workers.CSVFetcher do
  @moduledoc """
  Periodically fetches the CSV dataset from an external provider and stores it in memory.

  This Genserver, scheduled via Task with Quantum, ensures that the latest dataset is retrieved daily,
  keeping the room information up to date without requiring manual intervention.
  In case of failure, it retries up to @retry_interval times before logging the error.

  Storing the data in-memory (using ETS) to improving overall performance.
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

  # I chose Flow to efficiently process the CSV in parallel, leveraging multiple cores
  # to handle large datasets while maintaining performance. The partitioning strategy
  # optimizes workload distribution, ensuring smooth transformations and filtering.

  # Additionally, using ETS for storage allows ultra-fast lookups, making room queries
  # significantly more efficient compared to database queries. This improves the
  # overall responsiveness of the system, especially as data volume grows.
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
