defmodule Bookings.Workers.CSVFetcher.Helpers do
  @moduledoc """
  Helper functions for the CSVFetcher worker.
  """
  import Bookings.Utils, only: [normalize_string: 1]

  require Logger

  alias Bookings.Places
  alias Bookings.Places.Room

  @download_path "static/data/rooms.csv"

  @spec cast_row_to_changeset(list()) :: Ecto.Changeset.t()
  def cast_row_to_changeset(line) do
    [
      url,
      title,
      price_per_night,
      currency,
      city,
      state,
      country,
      amenities,
      rating_cleanliness,
      rating_accuracy,
      rating_check_in,
      rating_communication,
      rating_location,
      rating_value,
      rating_overall,
      total_reviews,
      created_at
    ] = line

    Places.change_room(%Room{}, %{
      url: url,
      title: title,
      price_per_night: price_per_night,
      currency: currency,
      city: city,
      state: state,
      country: country,
      amenities: amenities,
      rating_cleanliness: rating_cleanliness,
      rating_accuracy: rating_accuracy,
      rating_check_in: rating_check_in,
      rating_communication: rating_communication,
      rating_location: rating_location,
      rating_value: rating_value,
      rating_overall: rating_overall,
      total_reviews: total_reviews,
      created_at: created_at
    })
  end

  @spec validate_changeset(Ecto.Changeset.t()) :: boolean()
  def validate_changeset(changeset) do
    # can send a notify or log rooms that are not valid
    unless changeset.valid? do
      Logger.warning("Invalid room: #{inspect(changeset.errors)}")
    end

    changeset.valid?
  end

  @spec normalize_room(map()) :: map()
  def normalize_room(changeset) do
    changeset
    |> Ecto.Changeset.apply_changes()
    |> normalize_state()
    |> parse_amenities()
  end

  @state_mappings %{
    "distrito federal" => "Ciudad de México",
    "df" => "Ciudad de México",
    "cdmx" => "Ciudad de México",
    "cf" => "Ciudad de México",
    "méxico" => "Estado de México",
    "edomex" => "Estado de México"
  }

  @spec normalize_state(map()) :: map()
  def normalize_state(%{state: state} = room) do
    normalized_state = Map.get(@state_mappings, normalize_string(state), state)

    %{room | state: normalized_state}
  end

  defp parse_amenities(%{amenities: amenities_str} = room) do
    case Jason.decode(amenities_str) do
      {:ok, amenities} when is_list(amenities) ->
        %{room | amenities: amenities}

      _default_case ->
        room
    end
  end

  @spec csv_path() :: String.t()
  def csv_path do
    Path.join(:code.priv_dir(:bookings_web), @download_path)
  end
end
