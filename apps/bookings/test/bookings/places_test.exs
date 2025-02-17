defmodule Bookings.PlacesTest do
  use Bookings.DataCase

  alias Bookings.Places

  describe "rooms" do
    alias Bookings.Places.Room

    import Bookings.PlacesFixtures

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Places.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Places.get_room!(room.id) == room
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Places.change_room(room)
    end
  end
end
