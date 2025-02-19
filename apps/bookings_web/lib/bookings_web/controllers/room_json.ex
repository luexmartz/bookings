defmodule BookingsWeb.RoomJSON do
  alias Bookings.Places.Room

  @doc """
  Renders a list of rooms.
  """
  def index(%{rooms: rooms}) do
    %{data: for(room <- rooms, do: data(room))}
  end

  @doc """
  Renders a single room.
  """
  def show(%{room: room}) do
    %{data: data(room)}
  end

  defp data(%Room{} = room) do
    %{
      url: room.url,
      title: room.title,
      price_per_night: room.price_per_night,
      currency: room.currency,
      city: room.city,
      state: room.state,
      country: room.country,
      amenities: room.amenities,
      rating_cleanliness: room.rating_cleanliness,
      rating_accuracy: room.rating_accuracy,
      rating_check_in: room.rating_check_in,
      rating_communication: room.rating_communication,
      rating_location: room.rating_location,
      rating_value: room.rating_value,
      rating_overall: room.rating_overall,
      total_reviews: room.total_reviews,
      created_at: room.created_at
    }
  end
end
