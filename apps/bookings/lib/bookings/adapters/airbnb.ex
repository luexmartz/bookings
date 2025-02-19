defmodule Bookings.Adapters.Airbnb do
  @moduledoc """
  Airbnb adapter.
  """

  import Bookings.HttpClient
  require Logger

  @doc """
    Get the CSV file from the Airbnb API or any other source.
  """
  @spec get(:csv) :: {:ok, map()} | {:error, map()}
  def get(:csv) do
    :airbnb
    |> build_conn(:get, "/data/rooms_Fullstackdata.csv")
    |> add_request_header("content-type", "application/json;")
    |> make_request()
  end

  def get(_references) do
    Logger.error("Unsupported request")
    {:error, %{message: "Unsupported request"}}
  end
end
