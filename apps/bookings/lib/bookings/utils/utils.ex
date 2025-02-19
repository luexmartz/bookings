defmodule Bookings.Utils do
  @moduledoc """
  Utility functions.
  """

  def normalize_string(string) do
    String.downcase(string) |> String.trim()
  end
end
