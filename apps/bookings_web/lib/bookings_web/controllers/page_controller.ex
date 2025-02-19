defmodule BookingsWeb.PageController do
  @moduledoc """
  Controller for the page.
  """

  use BookingsWeb, :controller

  def index(conn, _params) do
    json(conn, %{
      message: "API Collection",
      endpoints: [
        %{method: "GET", path: "/api/places", description: "Retrieve all places"}
      ]
    })
  end
end
