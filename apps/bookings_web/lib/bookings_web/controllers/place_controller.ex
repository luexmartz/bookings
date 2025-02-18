defmodule BookingsWeb.PlaceController do
  @moduledoc """
  Controller for managing places
  """

  use BookingsWeb, :controller

  alias Bookings.Places
  alias BookingsWeb.JsonValidations.PlacesJsonSchema

  action_fallback BookingsWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    with {:ok, _params} <- PlacesJsonSchema.validate_index_places(params),
         {:ok, places} <- Places.list_places(params) do
      render(conn, :index, places: places)
    end
  end
end
