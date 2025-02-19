defmodule BookingsWeb.CityController do
  @moduledoc """
  Controller for the dummy json cities resource.
  """

  use BookingsWeb, :controller

  alias Bookings.CityService

  action_fallback BookingsWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"q" => query}) do
    cities = CityService.get_cities(query)

    conn
    |> put_status(201)
    |> json(cities)
  end

  def index(conn, _params) do
    cities = CityService.get_cities()

    conn
    |> put_status(201)
    |> json(cities)
  end
end
