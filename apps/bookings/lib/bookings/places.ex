defmodule Bookings.Places do
  @moduledoc """
  The Places context.
  """
  require Logger

  alias Bookings.Adapters.Reservamos
  alias Bookings.Cache.RoomsETS
  alias Bookings.Places.Place
  alias Bookings.Places.Room

  @doc """
  Returns the list of places.

  ## Examples

      iex> list_places(%{})
      [%Place{}, ...]

  """
  @spec list_places(map()) :: {:ok, list(Place.t())} | {:error, map()}
  def list_places(params) do
    with {:ok, places} <- Reservamos.get(:places, params) do
      places
      |> Flow.from_enumerable()
      |> Flow.map(fn place_data ->
        case change_place(%Place{}, place_data) do
          %{valid?: true, changes: %{result_type: "city"}} = changeset ->
            place = Ecto.Changeset.apply_changes(changeset)
            %{place | rooms: list_rooms(Map.put(params, "city_name", place.city_name))}

          _invalid ->
            nil
        end
      end)
      |> Flow.filter(&(&1 != nil))
      |> Enum.to_list()
      |> then(&{:ok, &1})
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking place changes.

  ## Examples

      iex> change_place(place)
      %Ecto.Changeset{data: %Place{}}

  """
  @spec change_place(Place.t(), map()) :: Ecto.Changeset.t()
  def change_place(%Place{} = place, attrs \\ %{}) do
    Place.changeset(place, attrs)
  end

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms(%{})
      [%Room{}, ...]

  """
  @spec list_rooms(map()) :: list(Room.t())
  def list_rooms(%{"city_name" => city_name} = params) do
    city_name
    |> RoomsETS.filter_by_city()
    |> RoomsETS.filter_by_title(params["title"])
    |> RoomsETS.filter_by_rating_overall(params["min_rating"])
    |> RoomsETS.filter_by_max_price(params["max_price"])
    |> RoomsETS.filter_by_min_price(params["min_price"])
    |> RoomsETS.filter_by_amenity(params["amenity"])
    |> Enum.map(fn {_id, room} -> room end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  @spec change_room(Room.t(), map()) :: Ecto.Changeset.t()
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end
