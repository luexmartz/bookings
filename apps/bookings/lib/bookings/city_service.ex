defmodule Bookings.CityService do
  @moduledoc """
  Handles retrieving city data from the JSON file.
  """
  import Bookings.Utils, only: [normalize_string: 1]

  @json_file "static/data/mexico_cities.json"

  @spec get_cities(String.t() | nil) :: list()
  def get_cities(q \\ nil) do
    filter_by_query(read_json(), q)
  end

  defp read_json do
    json_path()
    |> File.read!()
    |> Jason.decode!()
  end

  defp filter_by_query(cities, nil), do: cities

  defp filter_by_query(cities, query) do
    query = normalize_string(query)

    Enum.filter(cities, fn city ->
      String.contains?(normalize_string(city["city_name"]), query)
    end)
  end

  defp json_path do
    Path.join(:code.priv_dir(:bookings_web), @json_file)
  end
end
