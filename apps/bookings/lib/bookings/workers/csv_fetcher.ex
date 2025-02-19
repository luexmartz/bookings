defmodule Bookings.Workers.CSVFetcher do
  @moduledoc """
  Fetches the CSV file from the Phoenix static directory at scheduled intervals.
  """

  use GenServer
  require Logger
  alias Bookings.Adapters.Airbnb

  @retry_interval :timer.minutes(1)
  @max_retries 3

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

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
    attempt_fetch(0)
    {:noreply, state}
  end

  @impl true
  def handle_info(:fetch_csv, state) do
    attempt_fetch(0)
    {:noreply, state}
  end

  @impl true
  def handle_info({:retry_fetch, retries}, state) do
    attempt_fetch(retries)
    {:noreply, state}
  end

  # Private functions

  defp attempt_fetch(retries) when retries < @max_retries do
    case Airbnb.get(:csv) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Finch.Response{status: status}} ->
        Logger.warning("Failed with status #{status}, retrying in #{@retry_interval} (#{retries + 1}/#{@max_retries})...")
        schedule_retry(retries + 1)

      {:error, reason} ->
        Logger.warning("Error fetching CSV: #{inspect(reason)}, retrying in #{@retry_interval} (#{retries + 1}/#{@max_retries})...")
        schedule_retry(retries + 1)
    end
  end

  defp attempt_fetch(_retries) do
    Logger.error("Maximum retries reached. Stopping fetch.")
  end

  defp schedule_retry(retries) do
    Process.send_after(self(), {:retry_fetch, retries}, @retry_interval)
  end
end
