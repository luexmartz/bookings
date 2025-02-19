defmodule Bookings.Places.Place do
  @moduledoc """
  The Place schema is used to validate external place data using Ecto.Changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Bookings.Places.Room

  @required_fields [
    :id,
    :slug,
    :city_slug,
    :display,
    :ascii_display,
    :city_name,
    :city_ascii_name,
    :state,
    :country,
    :lat,
    :long,
    :result_type
  ]
  @optional_fields [:popularity, :sort_criteria]

  @type t() :: %__MODULE__{
          id: integer(),
          ascii_display: String.t(),
          city_ascii_name: String.t(),
          city_name: String.t(),
          city_slug: String.t(),
          country: String.t(),
          display: String.t(),
          lat: String.t(),
          long: String.t(),
          popularity: String.t(),
          result_type: String.t(),
          slug: String.t(),
          sort_criteria: Decimal.t(),
          state: String.t(),
          rooms: list(Room.t())
        }

  @primary_key {:id, :id, autogenerate: false}
  embedded_schema do
    field(:ascii_display, :string)
    field(:city_ascii_name, :string)
    field(:city_name, :string)
    field(:city_slug, :string)
    field(:country, :string)
    field(:display, :string)
    field(:lat, :string)
    field(:long, :string)
    field(:popularity, :string)
    field(:result_type, :string)
    field(:slug, :string)
    field(:sort_criteria, :decimal)
    field(:state, :string)
    embeds_many(:rooms, Room)
  end

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(place, attrs) do
    place
    |> cast(attrs, @required_fields)
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
  end
end
