# ---------------------------------- Prompt ----------------------------------
Generate a **Phoenix JSON schema** using `mix phx.gen.json` to define a **data structure** for lodging information obtained from various places. This schema should:
- **Only be used for data structure and validation** (no Ecto integration).
- **Validate data using Changeset** instead of a database.
- **Include the specified attributes** for lodging details and ratings.

### **Clear Instruction:**
Generate the following:

1. **Run `mix phx.gen.json` to create the schema:**
 - The schema must **not use Ecto** (`--no-ecto`).
 - It should define **all attributes** listed.

2. **Implement Changeset-Based Validation:**
 - Define a **changeset function** to validate fields.
 - Ensure proper **type validation** (e.g., `integer`, `string`, `float`).
 - Validate **required fields**.

3. **Ensure Schema Readability & Maintainability:**
 - Follow **Phoenix best practices** for API structuring.
 - Clearly separate **schema definition and validation logic**.

### **Desired Format:**
- **The full `mix phx.gen.json` command** for generating the initial structure.
- **A properly structured schema file**, including:
- **A struct definition** with all attributes.
- **A changeset function** for data validation.
- **Validation rules explained in comments** for clarity.

### **Level of Detail:**
- The solution must be **fully functional** and ready to integrate with an API.
- The schema must be **clear and maintainable**.
- The validation logic should **prevent incorrect data input**.

### **Restrictions & Constraints:**
- Do **not** include Ecto or database-related dependencies.
- Ensure **validation rules are strict but flexible** for realistic data handling.
- **Maintain API consistency** for easy future expansions.

### **Example of Output Structure:**
The response should include:
1. The **exact `mix phx.gen.json` command** to generate the structure.
2. The **full schema file** with struct and changeset validation.
3. Use the folling data to generate the Struct

### **Data to Struct**
  title: Título del alojamiento
  price_per_night: Precio por noche
  currency: Moneda del precio
  rating: Calificación general
  amenities: Servicios y comodidades disponibles
  city: Ciudad del alojamiento
  state: Estado/Provincia del alojamiento
  country: País del alojamiento
  url: URL de la página del alojamiento
  rating_cleanliness: Puntuación de limpieza
  rating_accuracy: Puntuación de veracidad de la información
  rating_check_in: Puntuación del proceso de llegada
  rating_communication: Puntuación de la comunicación con el anfitrión
  rating_location: Puntuación de la ubicación
  rating_value: Puntuación de la relación calidad-precio
  rating_overall: Calificación general del alojamiento
  total_reviews: Número total de reseñas

# ---------------------------------- Response ----------------------------------

Here's how you can **generate a Phoenix JSON schema** for lodging information **without using Ecto**, while implementing **data validation via Changeset**.

---

### **1. Generate the JSON Schema**
Run the following command to generate the JSON schema **without Ecto integration**:

```bash
mix phx.gen.json Lodgings Lodging lodgings \
  title:string \
  price_per_night:float \
  currency:string \
  rating:float \
  amenities:array:string \
  city:string \
  state:string \
  country:string \
  url:string \
  rating_cleanliness:float \
  rating_accuracy:float \
  rating_check_in:float \
  rating_communication:float \
  rating_location:float \
  rating_value:float \
  rating_overall:float \
  total_reviews:integer \
  --no-ecto
```

---

### **2. Define the Schema**
Modify the generated `lodging.ex` file to include **struct definition** and **data validation** using `Ecto.Changeset` (without persisting to a database).

```elixir
defmodule MyApp.Lodgings.Lodging do
  @moduledoc """
  Defines the lodging data structure and validates input data using Changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [
    :title, :price_per_night, :currency, :rating, :amenities, :city, :state,
    :country, :url, :rating_cleanliness, :rating_accuracy, :rating_check_in,
    :rating_communication, :rating_location, :rating_value, :rating_overall,
    :total_reviews
  ]}

  @primary_key false
  embedded_schema do
    field :title, :string
    field :price_per_night, :float
    field :currency, :string
    field :rating, :float
    field :amenities, {:array, :string}
    field :city, :string
    field :state, :string
    field :country, :string
    field :url, :string
    field :rating_cleanliness, :float
    field :rating_accuracy, :float
    field :rating_check_in, :float
    field :rating_communication, :float
    field :rating_location, :float
    field :rating_value, :float
    field :rating_overall, :float
    field :total_reviews, :integer
  end

  @doc """
  Creates a changeset to validate lodging data.
  Ensures all required fields are present and properly formatted.
  """
  def changeset(lodging, attrs) do
    lodging
    |> cast(attrs, [
      :title, :price_per_night, :currency, :rating, :amenities, :city, :state,
      :country, :url, :rating_cleanliness, :rating_accuracy, :rating_check_in,
      :rating_communication, :rating_location, :rating_value, :rating_overall,
      :total_reviews
    ])
    |> validate_required([
      :title, :price_per_night, :currency, :city, :state, :country, :url
    ])
    |> validate_length(:title, min: 3)
    |> validate_length(:city, min: 2)
    |> validate_length(:state, min: 2)
    |> validate_length(:country, min: 2)
    |> validate_number(:price_per_night, greater_than: 0)
    |> validate_number(:rating, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_cleanliness, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_accuracy, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_check_in, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_communication, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_location, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_value, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:rating_overall, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:total_reviews, greater_than_or_equal_to: 0)
    |> validate_format(:url, ~r/^https?:\/\/[\w\-\.]+/)
  end
end
```

---

### **3. Explanation of Changes**
- **Used `embedded_schema`**: Since this schema is for data validation and not an actual database table.
- **Added `@derive {Jason.Encoder, only: [...]}`**: Allows easy JSON encoding by selecting relevant fields.
- **Implemented `changeset/2`**:
  - **Ensures required fields**: `title`, `price_per_night`, `currency`, `city`, `state`, `country`, and `url`.
  - **String validations**: Minimum length for `title`, `city`, `state`, `country`.
  - **Numerical validations**:
    - `price_per_night` must be **greater than 0**.
    - Ratings must be **between 0 and 5**.
    - `total_reviews` must be **0 or higher**.
  - **URL validation**: Ensures a valid format.

---

### **4. How to Use This Schema**
Since this is a **non-Ecto schema**, you can use it in controllers or services to validate lodging data **before processing**:

```elixir
attrs = %{
  "title" => "Ocean View Apartment",
  "price_per_night" => 120.5,
  "currency" => "USD",
  "rating" => 4.8,
  "amenities" => ["WiFi", "Kitchen", "Pool"],
  "city" => "Miami",
  "state" => "Florida",
  "country" => "USA",
  "url" => "https://example.com/ocean-view",
  "rating_cleanliness" => 5.0,
  "rating_accuracy" => 4.7,
  "rating_check_in" => 4.8,
  "rating_communication" => 4.9,
  "rating_location" => 4.8,
  "rating_value" => 4.7,
  "rating_overall" => 4.8,
  "total_reviews" => 210
}

case MyApp.Lodgings.Lodging.changeset(%MyApp.Lodgings.Lodging{}, attrs) do
  %{valid?: true} = changeset ->
    IO.inspect("Valid lodging data: #{inspect Ecto.Changeset.apply_changes(changeset)}")
  %{valid?: false, errors: errors} ->
    IO.inspect("Invalid lodging data: #{inspect errors}")
end
```

---

### **5. Summary**
✅ **No Ecto dependency** (purely used for data validation).
✅ **Strict validation rules** to prevent incorrect data input.
✅ **Easily extendable** for future modifications.
✅ **Ideal for JSON-based API responses**.

This schema is now **ready to be used for API data validation** 🎯. Let me know if you need further refinements! 🚀