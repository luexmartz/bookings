defmodule BookingsWeb.RoomControllerTest do
  use BookingsWeb.ConnCase

  alias Bookings.Places.Room

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, ~p"/api/rooms")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
