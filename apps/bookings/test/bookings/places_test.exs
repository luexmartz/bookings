defmodule Bookings.PlacesTest do
  use ExUnit.Case, async: true

  alias Bookings.Places

  describe "places" do
    test "list_places/0 returns all places" do
      assert Places.list_places(%{}) == []
    end

    test "change_place/1 returns a place changeset" do
      assert %Ecto.Changeset{} = Places.change_place(%Places.Place{})
    end
  end
end
