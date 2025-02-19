defmodule BookingsWeb.PlaceJSON do
  @moduledoc """
  This module is responsible for rendering places in JSON format.
  """

  alias Bookings.Places.Place
  alias BookingsWeb.RoomJSON

  @doc """
  Renders a list of places.
  """
  @spec index(map()) :: map()
  def index(%{places: places}) do
    %{places: for(place <- places, do: data(place))}
  end

  defp data(%Place{} = place) do
    %{
      id: place.id,
      slug: place.slug,
      city_slug: place.city_slug,
      display: place.display,
      ascii_display: place.ascii_display,
      city_name: place.city_name,
      city_ascii_name: place.city_ascii_name,
      state: place.state,
      country: place.country,
      lat: place.lat,
      long: place.long,
      result_type: place.result_type,
      popularity: place.popularity,
      sort_criteria: place.sort_criteria,
      rooms: RoomJSON.index(%{rooms: place.rooms})
    }
  end
end
