defmodule Bookings.PlacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookings.Places` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        amenities: "some amenities",
        city: "some city",
        country: "some country",
        created_at: ~U[2025-02-16 19:48:00Z],
        currency: "some currency",
        price_per_night: "120.5",
        rating_accuracy: 120.5,
        rating_check_in: 120.5,
        rating_cleanliness: 120.5,
        rating_communication: 120.5,
        rating_location: 120.5,
        rating_overall: "120.5",
        rating_value: 120.5,
        state: "some state",
        title: "some title",
        total_reviews: 42,
        url: "some url"
      })

    # TODO: Insert the room into the cache

    room
  end
end
