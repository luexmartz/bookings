# ---------------------------------- Prompt ----------------------------------
Create an **Elixir module** that encapsulates all logic for managing an **ETS (Erlang Term Storage) table**. This module should provide a structured interface to **store, retrieve, and filter data efficiently**.

### **Clear Instruction:**
Generate an **Elixir module** that:

1. **Defines the ETS table name as a constant.**
   - Use a **module attribute** for the table name.

2. **Handles data storage as tuples.**
   - Ensure **ETS entries** are stored in a structured format.

3. **Implements a function to create the ETS table (if it does not exist).**
   - The table should be:
     - **Named correctly**.
     - Created with the **right access permissions** (`public` or `protected`).
     - Support **key-value lookups**.

4. **Implements a function to retrieve all stored data.**
   - Should return a **list of stored tuples**.

5. **Implements a function to clear all stored data (if it exists).**
   - Should **delete all entries** while keeping the table intact.

6. **Implements functions for searching by filters:**
   - **Search by `city`.**
   - **Search by `rate`.**
   - **Search by `amenities`.**
   - Other **custom search functions** based on different criteria.

7. **Ensure efficient lookups.**
   - Use **ETS match patterns** or **`:ets.select/2`** for optimized filtering.

### **Desired Format:**
- Provide a **fully functional Elixir module**.
- Use **clear function names** and **structured documentation (`@doc`)**.
- Implement **pattern matching** for efficient searches.

### **Level of Detail:**
- Ensure the module is **well-structured and idiomatic** to Elixir.
- Optimize functions for **performance and maintainability**.

### **Restrictions & Constraints:**
- Do **not** use a database (this is an ETS-only solution).
- Ensure **thread safety** and proper **ETS ownership handling**.
- Keep the **API intuitive** for future expansion.

### **Example of Output Structure:**
The response should include:
1. **A complete Elixir module** with the required functions.
2. **A well-documented `@moduledoc`** explaining the purpose of the module.

# ---------------------------------- Response ----------------------------------

defmodule MyApp.RoomsDataTable do
  @moduledoc """
  A module to manage an ETS table for storing and querying room information efficiently.
  This module provides structured functions for:
  - Creating the ETS table if it does not exist.
  - Storing and retrieving data.
  - Filtering data based on multiple criteria.
  - Ensuring optimized lookups using ETS match patterns.
  """

  @table_name :rooms_data

  @doc "Returns the name of the ETS table."
  def table_name, do: @table_name

  @doc "Creates the ETS table if it does not already exist."
  def create_table do
    unless :ets.whereis(@table_name) != :undefined do
      :ets.new(@table_name, [:named_table, :set, :public, :write_concurrency, :read_concurrency])
    end
  end

  @doc "Saves a list of tuples into the ETS table."
  def save_data(data) when is_list(data) do
    create_table()
    :ets.insert(@table_name, data)
  end

  @doc "Returns all the data stored in the ETS table."
  def get_all_data do
    case :ets.whereis(@table_name) do
      :undefined -> []
      _ -> :ets.tab2list(@table_name)
    end
  end

  @doc "Clears all data in the ETS table if it exists."
  def clear_data do
    if :ets.whereis(@table_name) != :undefined do
      :ets.delete_all_objects(@table_name)
    end
  end

  @doc "Finds records based on a city filter."
  def find_by_city(city) do
    create_table()
    :ets.select(@table_name, [{{:_, :_, :_, ^city, :_, :_, :_, :_}, [], [:"$_"]}])
  end

  @doc "Finds records based on a minimum rating."
  def find_by_min_rating(min_rating) do
    create_table()
    :ets.select(@table_name, [{{:_, :_, :_, :_, :_, :_, :_, rating}, [{:>=, rating, min_rating}], [:"$_"]}])
  end

  @doc "Finds records containing specific amenities."
  def find_by_amenities(required_amenities) when is_list(required_amenities) do
    create_table()
    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, _title, _price, _currency, _city, _state, _country, amenities, _rating} ->
      Enum.all?(required_amenities, &Enum.member?(amenities, &1))
    end)
  end

  @doc "Finds records based on multiple filters: city, rating, and amenities."
  def find_by_filters(filters) do
    create_table()
    :ets.tab2list(@table_name)
    |> Enum.filter(fn {_id, _title, _price, _currency, city, _state, _country, amenities, rating} ->
      matches_city?(filters[:city], city) and
      matches_rating?(filters[:min_rating], rating) and
      matches_amenities?(filters[:amenities], amenities)
    end)
  end

  defp matches_city?(nil, _city), do: true
  defp matches_city?(filter_city, city), do: filter_city == city

  defp matches_rating?(nil, _rating), do: true
  defp matches_rating?(min_rating, rating), do: rating >= min_rating

  defp matches_amenities?(nil, _amenities), do: true
  defp matches_amenities?(required, amenities) do
    Enum.all?(required, &Enum.member?(amenities, &1))
  end
end
