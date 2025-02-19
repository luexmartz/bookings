defmodule BookingsWeb.RoomController do
  use BookingsWeb, :controller

  alias Bookings.Places
  # alias Bookings.Places.Room

  action_fallback BookingsWeb.FallbackController

  def index(conn, _params) do
    rooms = Places.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  def show(conn, %{"id" => id}) do
    room = Places.get_room!(id)
    render(conn, :show, room: room)
  end
end
