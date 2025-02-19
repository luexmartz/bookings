defmodule Bookings.Places do
  @moduledoc """
  The Places context.
  """

  alias Bookings.Places.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    # TODO: Get all rooms from the cache
    [
      %Room{title: "Room 1"},
      %Room{title: "Room 2"},
      %Room{title: "Room 3"}
    ]
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(_id) do
    # TODO: Get the room with the given `id` from the cache
    %Room{title: "Room 1"}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end
