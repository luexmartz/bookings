defmodule BookingsWeb.RoomJSON do
  alias Bookings.Places.Room

  @doc """
  Renders a list of rooms.
  """
  def index(%{rooms: rooms}) do
    for(room <- rooms, do: data(room))
  end

  defp data(%Room{} = room) do
    Map.take(room, [
      :title,
      :price_per_night,
      :amenities,
      :rating_overall
    ])
  end
end
