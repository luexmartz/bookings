defmodule Bookings.Adapters.Airbnb do
  @moduledoc """
  Airbnb adapter.
  """

  import Bookings.HttpClient
  require Logger

  @doc """
    Get the CSV file from the Airbnb API or any other source.
  """
  @spec get(atom()) :: {:ok, map()} | {:error, map()}
  def get(:csv) do
    :airbnb
    |> build_conn(:get, "/data/rooms_Fullstackdata.csv")
    |> add_request_header("content-type", "application/json;")
    |> make_request()
    |> case do
      {:ok, %Finch.Response{status: 200, body: data}} ->
        {:ok, data}

      {:ok, %Finch.Response{}} ->
        {:error, %{message: "Unexpected response"}}

      {:error, error} ->
        Logger.error("Error fetching CSV: #{inspect(error)}")
        {:error, error}
    end
  end

  @spec get(atom()) :: {:error, map()}
  def get(_) do
    Logger.error("Unsupported request")
    {:error, %{message: "Unsupported request"}}
  end
end
