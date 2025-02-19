defmodule BookingsWeb.PlaceControllerTest do
  use BookingsWeb.ConnCase

  alias Bookings.Places.Place

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all places", %{conn: conn} do
      conn = get(conn, ~p"/api/places")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
