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

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Places.change_room(room)
    end
  end

  describe "places" do
    alias Bookings.Places.Place

    import Bookings.PlacesFixtures

    test "list_places/0 returns all places" do
      place = place_fixture()
      assert Places.list_places() == [place]
    end

    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Places.change_place(place)
    end
  end
end
