defmodule BookingsWeb.JsonValidations.JsonSchema do
  @moduledoc """
  JSON schema.
  """

  def validate(params) do
    {:ok, params}
  end

  @spec validate(map(), map()) :: {:ok, map()} | {:error, map()}
  def validate(schema, params) do
    with {:ok, json_schema} <- parse_schema(schema),
         :ok <- ExJsonSchema.Validator.validate(json_schema, params) do
      {:ok, params}
    else
      {:error, errors} ->
        json_error_parser(errors)
    end
  end

  defp parse_schema(json) do
    {:ok, ExJsonSchema.Schema.resolve(json)}
  end

  defp json_error_parser(errors) do
    result =
      Enum.map(errors, fn {k, v} ->
        k =
          k
          |> String.replace("String", "")
          |> String.replace("\"", "")
          |> String.trim()

        v =
          v
          |> String.replace("#", "")
          |> String.replace("\"", "")
          |> case do
            "" -> "error"
            value -> value
          end

        {:"#{v}", "#{k}"}
      end)

    {:error, result}
  end
end
