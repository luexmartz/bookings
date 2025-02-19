defmodule Bookings.Utils do
  @moduledoc """
  Utility functions.
  """

  @spec normalize_string(String.t()) :: String.t()
  def normalize_string(string) do
    String.downcase(string) |> String.trim()
  end
end
