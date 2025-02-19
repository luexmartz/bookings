defmodule BookingsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BookingsWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: BookingsWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: BookingsWeb.ErrorHTML, json: BookingsWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, %{message: message}}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: BookingsWeb.ErrorJSON)
    |> render(:error, message: message)
  end

  def call(conn, {:error, %Mint.TransportError{reason: :nxdomain}}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: BookingsWeb.ErrorJSON)
    |> render(:error, message: "Invalid domain")
  end

  def call(conn, {:error, errors}) when is_list(errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: format_json_errors(errors)})
  end

  def call(conn, {:error, _reason}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(json: BookingsWeb.ErrorJSON)
    |> render(:error, message: "Internal server error")
  end

  defp format_json_errors(errors) do
    Enum.map(errors, fn
      {:error, message} -> %{field: "general", error: message}
      {field, message} -> %{field: field, error: message}
    end)
  end
end
