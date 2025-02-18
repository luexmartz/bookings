defmodule Bookings.Cache.RoomsETS do
  @moduledoc """
  A module to manage the ETS table for storing and querying room information.
  """

  import Bookings.Utils, only: [normalize_string: 1]
  alias Bookings.Places.Room
  alias Decimal

  @table_name :rooms

  def table_name, do: @table_name

  @spec create_table() :: :ok
  def create_table do
    if :ets.whereis(@table_name) == :undefined do
      :ets.new(@table_name, [:named_table, :set, :public, {:write_concurrency, true}])
    end
  end

  @spec insert_batch(list(Room.t())) :: :ok
  def insert_batch(batch) when is_list(batch) do
    :ets.insert(@table_name, Enum.map(batch, fn room -> {make_ref(), room} end))
  end

  @spec get_all_data() :: list(Room.t())
  def get_all_data do
    case :ets.whereis(@table_name) do
      :undefined -> []
      _ -> :ets.tab2list(@table_name) |> Enum.map(fn {_id, room} -> room end)
    end
  end

  @spec get_count_of_data() :: integer
  def get_count_of_data do
    case :ets.whereis(@table_name) do
      :undefined -> 0
      _ -> :ets.tab2list(@table_name) |> length()
    end
  end

  @spec initialize_data() :: :ok
  def initialize_data do
    if :ets.whereis(@table_name) != :undefined do
      :ets.delete_all_objects(@table_name)
    else
      create_table()
    end
  end

  @spec find_by_title(String.t()) :: list(Room.t())
  def find_by_title(title), do: find_by(:title, title)

  @spec find_by_city(String.t()) :: list(Room.t())
  def find_by_city(city), do: find_by(:city, city)

  defp find_by(field, query) when is_binary(query) and is_atom(field) do
    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, room} ->
      value = Map.get(room, field, "")

      is_binary(value) and
        String.contains?(value, normalize_string(query))
    end)
    |> Enum.map(fn {_id, room} -> room end)
  end

  @state_aliases %{
    "ciudad de méxico" => ["distrito federal", "cdmx"]
  }

  @spec find_by_state(String.t()) :: list(Room.t())
  def find_by_state(state) do
    normalized_state = normalize_string(state)

    matching_states =
      @state_aliases
      |> Enum.flat_map(fn {canonical, aliases} ->
        all_names = [canonical | aliases]
        if Enum.any?(all_names, &String.contains?(&1, normalized_state)) do
          all_names
        else
          []
        end
      end)
      |> Enum.uniq()

    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, %{state: stored_state}} ->
      String.contains?(stored_state, normalized_state) or stored_state in matching_states
    end)
    |> Enum.map(fn {_id, room} -> room end)
  end

  @spec find_by_rating_overall(String.t()) :: list(Room.t())
  def find_by_rating_overall(rating) do
    rating_decimal = Decimal.new(rating)

    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, %{rating_overall: stored_rating}} ->
      Decimal.compare(stored_rating, rating_decimal) in [:gt, :eq]
    end)
    |> Enum.map(fn {_id, room} -> room end)
  end

  @spec find_by_max_price(String.t()) :: list(Room.t())
  def find_by_max_price(price) do
    price_decimal = Decimal.new(price)

    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, %{price_per_night: stored_price}} ->
      Decimal.compare(stored_price, price_decimal) in [:lt, :eq]
    end)
    |> Enum.map(fn {_id, room} -> room end)
  end

  @spec find_by_min_price(String.t()) :: list(Room.t())
  def find_by_min_price(price) do
    price_decimal = Decimal.new(price)

    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, %{price_per_night: stored_price}} ->
      Decimal.compare(stored_price, price_decimal) in [:gt, :eq]
    end)
    |> Enum.map(fn {_id, room} -> room end)
  end
end
