# Bookings.Umbrella

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Running Format](#running-format)
- [Running Checks](#running-checks)
- [Filters](#filters)
- [Example Request](#example-request)
- [Switching to Localhost Manually](#switching-to-localhost-manually)
- [Prompt Documentation](#prompt-documentation)
- [Why an Umbrella Project](#why-an-umbrella-project)

## Prerequisites

Before starting, ensure you have the following tools installed:

- **Elixir**: Version 1.18 or higher.
- **Erlang/OTP**: Version 27 or higher.

## Installation

Follow these steps to set up the local development environment:

**Clone the repository**:

```bash
git clone https://github.com/luexmartz/bookings.git
cd bookings
```

**Install Elixir dependencies**:

```bash
mix deps.get
```

## Running the Application

**To start the application in development mode**:

```bash
mix phx.server
```

**You can also run your app inside IEx (Interactive Elixir) as**:

```bash
iex -S mix phx.server
```

**Prefer using Docker?** Run the app in a container instead:

```bash
# Build the Docker image
docker-compose build

# Start the container
docker-compose up
```

Then, access the `/api` at **[http://localhost:4000](http://localhost:4000)**.

## Running Format

**To run the code formatter**:

```bash
mix format
```

## Running Checks

**To run the code analysis**:

```bash
mix credo --strict
```

## Filters

The supported filters for the API are defined in `places_json_schema`.
More filters can be added if necessary.

You can find the schema at:
[/bookings_web/json_validations/places_json_schema.ex](/apps/bookings_web/lib/bookings_web/json_validations/places_json_schema.ex)

### Supported Filters:

- **q**: Filter places by city name (e.g., "Monterrey").
- **title**: Filter rooms by title (e.g., "Fundidora").
- **min_rating**: Filter rooms by minimum rating (e.g., 4.5).
- **max_price**: Filter rooms by maximum price (e.g., 800).
- **min_price**: Filter rooms by minimum price (e.g., 200.50).
- **amenity**: Filter rooms by specific amenities (e.g., "calefacción").

## Example Request

```bash
curl --location 'http://localhost:4000/api/places?q=monterrey&title=fundidora&min_rating=4.5&max_price=800&min_price=200.50&amenity=calefacci%C3%B3n'
```

### Response Example:

```json
{
  "places": [
    {
      "id": 19,
      "display": "Monterrey",
      "state": "Nuevo León",
      "long": "-100.3161126",
      "result_type": "city",
      "rooms": [
        {
          "title": "Monterrey 1 habitación cerca d Fundidora y centro",
          "rating_overall": "4.66",
          "price_per_night": "310.0",
          "amenities": [
            "Espacios al aire libre",
            "Aire acondicionado y calefacción",
            "Ropa de cama incluida",
            "Caja de seguridad"
          ]
        }
      ],
      "country": "México",
      "city_name": "Monterrey",
      "ascii_display": "monterrey",
      "city_ascii_name": "monterrey",
      "city_slug": "monterrey",
      "lat": "25.6866142",
      "popularity": "0.365111433802639",
      "slug": "monterrey",
      "sort_criteria": "0.7460445735210556"
    }
  ]
}
```

## Switching to Localhost Manually

  If requests to **`https://search.reservamos.mx/api/v2`** fail due to **network issues, downtime, or API restrictions**, you can manually switch to **localhost (`http://localhost:4000/cities`)** by updating your config environment variable and using the internal `/cities` service.

  #### **How to Manually Change the API URL to Localhost**

  ##### 1 Modify **`config/dev.exs`**

  ```elixir
  config :bookings, :reservamos,
  url: System.get_env("RESERVAMOS_URL", "http://localhost:4000")
  ```

  ##### 2 Modify the function **`Reservamos.get`** in `reservamos.ex`
  ```elixir
  :reservamos
  |> build_conn(:get, "/cities")
  ```

  This ensures that the local API (`http://localhost:4000/cities`) is used


## Prompt Documentation

Some AI prompts used in this challenge are documented in a dedicated folder. You can find them at:

[/prompts](/prompts)

## Why an Umbrella Project

I decided to use an **umbrella project** to keep the system **modular, maintainable, and scalable**. This approach allows us to:

1. **Separate Concerns Clearly**

- Each part of the system (e.g., `Bookings`, `BookingsWeb`) is its own **isolated application**.
- This makes it easier to **test, maintain, and scale** without affecting other components.

2. **Improve Code Organization**

- By splitting **business logic** (contexts) from the **web layer**, I ensure that the core functionality is **reusable** and not tightly coupled to Phoenix.
- This also makes future refactors or expansions simpler.

3. **Optimize Performance & Deployments**

- Each application in the umbrella can be **compiled and deployed independently**, reducing downtime and improving flexibility.
- Background workers, caches, and external integrations can run **as separate apps** while still sharing data efficiently.

4. **Make the System Scalable**

- As the project grows, I can **add new apps** inside the umbrella without disrupting existing functionality.
- This allows the system to evolve in a **structured and maintainable way**.

This structure gives the flexibility to **grow the project without introducing unnecessary complexity**, keeping everything **modular and easy to manage**.
