defmodule Bookings.Places.Room do
  @moduledoc """
  Schema for validating romm data using Ecto.Changeset
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :amenities,
    :city,
    :country,
    :created_at,
    :currency,
    :price_per_night,
    :rating_overall,
    :state,
    :title,
    :total_reviews,
    :url
  ]
  @optional_fields [
    :rating_accuracy,
    :rating_check_in,
    :rating_cleanliness,
    :rating_communication,
    :rating_location,
    :rating_value
  ]

  @type t() :: %__MODULE__{
          amenities: [String.t()],
          city: String.t(),
          country: String.t(),
          created_at: DateTime.t(),
          currency: String.t(),
          price_per_night: Decimal.t(),
          rating_accuracy: float(),
          rating_check_in: float(),
          rating_cleanliness: float(),
          rating_communication: float(),
          rating_location: float(),
          rating_overall: Decimal.t(),
          rating_value: float(),
          state: String.t(),
          title: String.t(),
          total_reviews: integer(),
          url: String.t()
        }

  @primary_key false
  embedded_schema do
    field(:amenities, :string)
    field(:city, :string)
    field(:country, :string)
    field(:created_at, :utc_datetime)
    field(:currency, :string)
    field(:price_per_night, :decimal)
    field(:rating_accuracy, :float)
    field(:rating_check_in, :float)
    field(:rating_cleanliness, :float)
    field(:rating_communication, :float)
    field(:rating_location, :float)
    field(:rating_overall, :decimal)
    field(:rating_value, :float)
    field(:state, :string)
    field(:title, :string)
    field(:total_reviews, :integer)
    field(:url, :string)
  end

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(room, attrs) do
    room
    |> cast(attrs, @required_fields)
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:price_per_night, greater_than_or_equal_to: 0)
    |> validate_number(:rating_cleanliness, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_accuracy, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_check_in, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_communication,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 5
    )
    |> validate_number(:rating_location, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_value, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_overall, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:total_reviews, greater_than_or_equal_to: 0)
    |> validate_format(:url, ~r/^https?:\/\/[^\s]+$/)
  end
end
