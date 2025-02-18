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

  @spec filter_by_city(String.t()) :: list(Room.t())
  def filter_by_city(city) do
    @table_name
    |> :ets.tab2list()
    |> Stream.filter(fn {_id, room} ->
      String.contains?(normalize_string(room.city), normalize_string(city))
    end)
  end

  @spec filter_by_title(list(), String.t() | nil) :: list(Room.t())
  def filter_by_title(rooms_stream, nil), do: rooms_stream

  def filter_by_title(rooms_stream, title) do
    rooms_stream
    |> Stream.filter(fn {_id, room} ->
      String.contains?(normalize_string(room.title), normalize_string(title))
    end)
  end

  @spec filter_by_rating_overall(list(), String.t() | nil) :: list(Room.t())
  def filter_by_rating_overall(rooms_stream, nil), do: rooms_stream

  def filter_by_rating_overall(rooms_stream, rating) do
    rating_decimal = Decimal.new(rating)

    rooms_stream
    |> Stream.filter(fn {_id, %{rating_overall: stored_rating}} ->
      Decimal.compare(stored_rating, rating_decimal) in [:gt, :eq]
    end)
  end

  @spec filter_by_max_price(list(), String.t() | nil) :: list(Room.t())
  def filter_by_max_price(rooms_stream, nil), do: rooms_stream

  def filter_by_max_price(rooms_stream, price) do
    price_decimal = Decimal.new(price)

    rooms_stream
    |> Stream.filter(fn {_id, %{price_per_night: stored_price}} ->
      Decimal.compare(stored_price, price_decimal) in [:lt, :eq]
    end)
  end

  @spec filter_by_min_price(list(), String.t() | nil) :: list(Room.t())
  def filter_by_min_price(rooms_stream, nil), do: rooms_stream

  def filter_by_min_price(rooms_stream, price) do
    price_decimal = Decimal.new(price)

    rooms_stream
    |> Enum.filter(fn {_id, %{price_per_night: stored_price}} ->
      Decimal.compare(stored_price, price_decimal) in [:gt, :eq]
    end)
  end

  @spec filter_by_amenity(list(), String.t()) :: list(Room.t())
  def filter_by_amenity(rooms_stream, nil), do: rooms_stream

  def filter_by_amenity(rooms_stream, amenity) do
    rooms_stream
    |> Stream.filter(fn {_id, room} ->
      Enum.any?(
        room.amenities,
        &String.contains?(normalize_string(&1), normalize_string(amenity))
      )
    end)
  end
end
