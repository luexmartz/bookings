defmodule Bookings.Places.Room do
  @moduledoc """
  Schema for validating romm data using Ecto.Changeset
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:url, :title, :price_per_night, :currency, :city, :state, :country, :amenities, :rating_overall, :total_reviews, :created_at]
  @optional_fields [:rating_cleanliness, :rating_accuracy, :rating_check_in, :rating_communication, :rating_location, :rating_value]

  @derive {Jason.Encoder, only: [
    :url, :title, :price_per_night, :currency, :city, :state, :country, :amenities,
    :rating_cleanliness, :rating_accuracy, :rating_check_in, :rating_communication,
    :rating_location, :rating_value, :rating_overall, :total_reviews, :created_at
  ]}

  @primary_key false
  embedded_schema do
    field :state, :string
    field :title, :string
    field :currency, :string
    field :url, :string
    field :price_per_night, :decimal
    field :city, :string
    field :country, :string
    field :amenities, :string
    field :rating_cleanliness, :float
    field :rating_accuracy, :float
    field :rating_check_in, :float
    field :rating_communication, :float
    field :rating_location, :float
    field :rating_value, :float
    field :rating_overall, :decimal
    field :total_reviews, :integer
    field :created_at, :utc_datetime

    timestamps()
  end

  # Alternative of use: TypedEctoSchema
  @type t :: %__MODULE__{
    title: String.t(),
    price_per_night: Decimal.t(),
    currency: String.t(),
    city: String.t(),
    state: String.t(),
    country: String.t()
  }

  @doc false
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(room, attrs) do
    room
    |> cast(attrs, @required_fields)
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
  end
end
