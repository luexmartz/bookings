# ---------------------------------- Prompt ----------------------------------
### **Purpose:**
Generate a new file.json with **JSON dataset** containing **50 unique city records** from Mexico. Each record must follow the exact structure of **`city_json`**, ensuring all parameters are included.

### **Clear Instruction:**
Generate a **JSON dataset with 50 unique cities** that:

1. **Includes all cities from the given `list_of_cities`** (mandatory).
2. **Generates additional unique Mexican cities** to reach 50 records (without repetition).
3. **Ensures valid format for each parameter**, including:
   - **Unique IDs** for all cities.
   - **Latitude & Longitude** (random but valid coordinates for Mexico).
   - **Popularity and sort_criteria** (invented but with realistic values).

### **Desired Format:**
- The response should be **a valid JSON array** of 50 city objects.
- Each object should **strictly follow the given `city_json` format**.
- Ensure **proper indentation** for readability.

### **Level of Detail:**
- The dataset should be **realistic and diverse**.
- Include **different regions of Mexico** to enhance variety.

### **Restrictions & Constraints:**
- **Do not omit any parameter** from the city structure.
- **Do not repeat the same city** in the dataset.
- **Ensure all IDs are unique**.
- **Latitude & longitude must be within Mexico’s geographic range**.

### **Example of Output Structure:**
The response should include:
1. **50 properly formatted JSON records.**
2. **All cities from `list_of_cities` included.**
3. **Valid geolocation and unique IDs for each record.**

**list_of_cities**
- Ciudad de México
- Guadalajara
- Monterrey
- Morelia
- Acapulco
- Puerto Vallarta
- León
- Tijuana
- Santiago de Querétaro
- San Luis Potosí
- Mazatlán
- Guanajuato
- Puebla
- Aguascalientes
- Toluca
- San Miguel de Allende

**city_json**
```json
[
  {
    "id": 19,
    "slug": "monterrey",
    "city_slug": "monterrey",
    "display": "Monterrey",
    "ascii_display": "monterrey",
    "city_name": "Monterrey",
    "city_ascii_name": "monterrey",
    "state": "Nuevo León",
    "country": "México",
    "lat": "25.6866142",
    "long": "-100.3161126",
    "result_type": "city",
    "popularity": "0.365111433802639",
    "sort_criteria": 0.7460445735210556
  }
]
```
# ---------------------------------- Response ----------------------------------
I have generated a JSON dataset with 50 unique city records from Mexico. You can download the file from the link below:

[Download mexico_cities.json]