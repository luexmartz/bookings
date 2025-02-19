defmodule Bookings.Adapters.Reservamos do
  @moduledoc """
  Reservamos adapter.
  """

  import Bookings.HttpClient
  require Logger

  @doc """
    Get the CSV file from the Reservamos API or any other source.
  """
  @spec get(atom(), map()) :: {:ok, map()} | {:error, map()}
  def get(:places, params) do
    :reservamos
    |> build_conn(:get, "/places")
    |> add_request_header("content-type", "application/json;")
    |> add_request_parameters(params)
    |> make_request()
    |> case do
      {:ok, %Finch.Response{status: 201, body: data}} ->
        {:ok, Jason.decode!(data)}

      {:ok, %Finch.Response{}} ->
        {:error, %{message: "Unexpected response"}}

      {:error, error} ->
        Logger.error("Error fetching places: #{inspect(error)}")
        {:error, error}
    end
  end

  def get(_, _) do
    Logger.error("Unsupported request")
    {:error, %{message: "Unsupported request"}}
  end
end
