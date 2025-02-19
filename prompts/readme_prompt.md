# ---------------------------------- Prompt ----------------------------------
   Generate a **README.md** file for a **Booking API project**, documenting API usage, setup instructions, and supported filters. The README should be **developer-friendly** and include clear examples.

   ### **Clear Instruction:**
   Generate a **README.md** file with the following sections:

   1. **Example `curl` Request & Response:**
   - Provide an example API request using `curl` that includes **all supported filters**.
   - Show a **sample JSON response** with results.

   2. **Required Versions:**
   - Document the **required Erlang and Elixir versions** for compatibility:
   - Erlang **27.1.2**
   - Elixir **1.18.1**

   3. **Code Formatting & Linting:**
   - Instructions on how to run **formatter (`mix format`)** and **Credo (`mix credo`)** for code consistency.

   4. **Prompts Documentation:**
   - Provide **info about prompts** used in the project.
   - Add a **link** to the folder containing prompts for this challenge.

   5. **Filters Information:**
   - Mention that **supported filters** are defined in `places_json_schema.ex`.
   - Provide a **direct link** to the file at:
   ```
   reservamos/bookings/apps/bookings_web/lib/bookings_web/json_validations/places_json_schema.ex
   ```
   - Document each **filter** briefly, including:
   - **Key**
   - **Description**
   - **Type**
   - **Validation Pattern (if applicable)**

   ### **Desired Format:**
   - The README must be in **Markdown format (`README.md`)**.
   - Use **clear headers (`#`, `##`, `###`)** for readability.
   - Include **code blocks** (e.g., for `curl` examples and JSON responses).
   - Provide **direct links** to relevant files.

   ### **Level of Detail:**
   - The README should be **concise but informative**.
   - Ensure **all necessary instructions are included** for developers to use and extend the API.

   ### **Restrictions & Constraints:**
   - Ensure the **API example is realistic** and matches the expected structure.
   - Keep explanations **clear and developer-friendly**.
   - Do **not** include unnecessary details—focus on **API usability and setup**.

   ### **Example of Output Structure:**
   The response should include:
   1. **A properly formatted `README.md` file** with all sections.
   2. **An example API request and response**.
   3. **A well-structured filter documentation table**.

# ---------------------------------- Response ----------------------------------

   ## Booking API

   ## Overview

   The **Booking API** provides lodging information from various sources. This API allows filtering of results based on location, amenities, pricing, and ratings.

   ## Table of Contents

   - [API Usage](#api-usage)
   - [Example Request](#example-request)
   - [Example Response](#example-response)
   - [Setup Instructions](#setup-instructions)
   - [Required Versions](#required-versions)
   - [Running the Application](#running-the-application)
   - [Code Formatting & Linting](#code-formatting--linting)
   - [Supported Filters](#supported-filters)
   - [Prompts Documentation](#prompts-documentation)

   ---

   ## API Usage

   ### Example Request

   To fetch booking data with filtering, use the following `curl` command:

   ```bash
   curl -X GET "http://localhost:4000/api/bookings?q=Monterrey&min_price=100&max_price=500&min_rating=4.5&amenity=WiFi" \
      -H "Content-Type: application/json"
   ```

   ### Example Response

   ```json
   {
   "data": [
      {
         "title": "Luxury Apartment in Monterrey",
         "price_per_night": 350.0,
         "currency": "MXN",
         "city": "Monterrey",
         "state": "Nuevo Leon",
         "country": "Mexico",
         "rating": 4.8,
         "amenities": ["WiFi", "Kitchen", "Pool"],
         "total_reviews": 120
      }
   ]
   }
   ```

   ---

   ## Setup Instructions

   ### Required Versions

   Ensure the following dependencies are installed:

   - **Erlang**: `27.1.2`
   - **Elixir**: `1.18.1`

   ### Running the Application

   Start the application in development mode:

   ```bash
   mix phx.server
   ```

   Alternatively, using **Docker**:

   ```bash
   # Build the Docker image
   docker-compose build

   # Run the container
   docker-compose up
   ```

   ### Code Formatting & Linting

   To format code:

   ```bash
   mix format
   ```

   To check for code consistency using Credo:

   ```bash
   mix credo --strict
   ```

   ---

   ## Supported Filters

   The API supports various filters to refine search results. These filters are defined in the [`places_json_schema.ex`](reservamos/bookings/apps/bookings_web/lib/bookings_web/json_validations/places_json_schema.ex) file.

   | Filter       | Description                             | Type   | Validation Pattern    |                             |
   | ------------ | --------------------------------------- | ------ | --------------------- | --------------------------- |
   | `q`          | Search by city name (e.g., "Monterrey") | String | -                     |                             |
   | `title`      | Filter by room title (e.g., "Hotel")    | String | -                     |                             |
   | `min_rating` | Minimum rating (e.g., 4.5)              | String | \`^[0-4](.\d{1,2})?\$ | ^5.0{1,2}$\`                |
   | `max_price`  | Maximum price (e.g., 500.00)            | String | \`^(0                 | [1-9][0-9]\*)(.\d{1,2})?$\` |
   | `min_price`  | Minimum price (e.g., 100.00)            | String | \`^(0                 | [1-9][0-9]\*)(.\d{1,2})?$\` |
   | `amenity`    | Filter by amenity (e.g., "WiFi")        | String | -                     |                             |

   ---

   ## Prompts Documentation

   For additional details on API query customization, refer to the prompt documentation in the dedicated folder:

   📂 **[Prompts Folder](./prompts/)**
