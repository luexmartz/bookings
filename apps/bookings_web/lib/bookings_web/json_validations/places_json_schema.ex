defmodule BookingsWeb.JsonValidations.PlacesJsonSchema do
  @moduledoc """
  JSON schema for places.
  """

  alias BookingsWeb.JsonValidations.JsonSchema

  @spec validate_index_places(map()) :: {:ok, map()} | {:error, map()}
  def validate_index_places(params) do
    schema =
      %{
        "title" => "Get all places with filters",
        "type" => "object",
        "maxProperties" => 6,
        "properties" => %{
          "q" => %{
            "description" => "Filter places by city name, e.g. 'Monterrey'",
            "type" => "string"
          },
          "title" => %{
            "description" => "Filter rooms by title, e.g. 'Hotel'",
            "type" => "string"
          },
          "min_rating" => %{
            "description" => "Filter rooms by minimum rating, e.g. 4.5",
            "type" => "string",
            "pattern" => "^[0-4](\\.\\d{1,2})?$|^5\\.0{1,2}$"
          },
          "max_price" => %{
            "description" => "Filter rooms by max price, e.g. 500.00",
            "type" => "string",
            "pattern" => "^(0|[1-9][0-9]*)(\\.\\d{1,2})?$"
          },
          "min_price" => %{
            "description" => "Filter rooms by min price, e.g. 100.00",
            "type" => "string",
            "pattern" => "^(0|[1-9][0-9]*)(\\.\\d{1,2})?$"
          },
          "amenity" => %{
            "description" => "Filter rooms by amenity, e.g. 'lavadora'",
            "type" => "string"
          }
        },
        "additionalProperties" => false,
        "required" => []
      }

    JsonSchema.validate(schema, params)
  end
end
