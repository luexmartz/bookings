defmodule BookingsWeb.RoomController do
  @moduledoc """
  Controller for managing rooms.
  """

  use BookingsWeb, :controller

  alias Bookings.Places

  action_fallback BookingsWeb.FallbackController

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    rooms = Places.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    room = Places.get_room!(id)
    render(conn, :show, room: room)
  end
end
