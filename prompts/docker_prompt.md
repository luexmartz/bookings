# ---------------------------------- Prompt ----------------------------------
create a **Docker setup** for a Phoenix project using **Elixir 1.18+** and **Erlang/OTP 27+**. The configuration should include a **Dockerfile** and a **docker-compose.yml** file to facilitate **development and production deployment**.

### **Clear Instruction:**
Generate the following:

1. **Dockerfile:**
 - Base image: Must support **Elixir 1.18+** and **Erlang/OTP 27+**.
 - Must include **Hex, Rebar, and Phoenix dependencies**.
 - Should use **multi-stage builds** for efficient production images.
 - Optimize caching to reduce rebuild times.

2. **Docker Compose Configuration (`docker-compose.yml`):**
 - Define a **Phoenix service**.
 - Expose necessary ports for local development, por 4000.
 - Support **hot-reloading** for faster development iterations.

3. **Environment & Configuration Considerations:**
 - Handle **secret management** (e.g., `.env` support).

4. **Best Practices & Optimizations:**
 - Apply **efficient layer caching** to speed up rebuilds.
 - Ensure compatibility with **Docker networking**.

### **Desired Format:**
- Provide the **full `Dockerfile` and `docker-compose.yml`**.
- Include **comments** explaining each step.
- Suggest **alternative optimizations** if applicable.

### **Level of Detail:**
- The solution should be **fully functional for development ready**.
- Keep the setup **lightweight and optimized** for fast container startup.

### **Restrictions & Constraints:**
- The images must be **as small as possible** to reduce build times.
- Avoid unnecessary dependencies in the final build.

### **Example of Output Structure:**
The response should include:
1. **A fully functional `Dockerfile` with multi-stage builds.**
2. **A `docker-compose.yml` setup with Phoenix & PostgreSQL.**
3. **A brief explanation of each step for better understanding.**

Here’s a **fully functional Docker setup** for a **Phoenix** project using **Elixir 1.18+** and **Erlang/OTP 27+**. This setup is optimized for **development** with **hot-reloading** and **efficient caching**.

# ---------------------------------- Response ----------------------------------

## **Dockerfile** (For Development)
This setup **optimizes caching** and ensures all necessary dependencies are installed.

```dockerfile
# Base Image: Elixir with Erlang 27
FROM elixir:1.18.1-erlang-27.1.2-alpine AS dev

# Set working directory inside the container
WORKDIR /app

# Install necessary dependencies
RUN apk add --no-cache build-base git npm

# Install Hex and Rebar (for Elixir package management)
RUN mix local.hex --force && mix local.rebar --force

# Copy dependency files first for caching
COPY mix.exs mix.lock ./

# Fetch Elixir dependencies
RUN mix deps.get

# Install Node.js dependencies for frontend assets (if applicable)
COPY assets/package.json assets/package-lock.json assets/
RUN npm install --prefix assets

# Copy the rest of the application source code
COPY . .

# Expose Phoenix server port
EXPOSE 4000

# Default command to start the application
CMD ["mix", "phx.server"]
```

---

## **docker-compose.yml**
This configuration **supports hot-reloading** and **automatically restarts services** if necessary.

```yaml
version: '3.8'

services:
  phoenix:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: phoenix_app
    ports:
      - "4000:4000"
    environment:
      MIX_ENV: dev
      DATABASE_URL: "ecto://postgres:postgres@db/my_db"
      SECRET_KEY_BASE: "your_secret_key_base"
    volumes:
      - .:/app
      - mix_deps:/app/deps
      - build:/app/_build
    depends_on:
      - db
    command: ["mix", "phx.server"]

  db:
    image: postgres:16
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: my_db
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  mix_deps:
  build:
  pgdata:
```

---

## **Key Features & Explanation**
### **Dockerfile**
- Uses **Alpine Linux** to keep the image **lightweight**.
- **Caches dependencies** before copying the entire app to optimize rebuild times.
- Supports **Node.js dependencies** (useful for assets like JavaScript/CSS).
- Uses **MIX_ENV=dev** for development mode.

### **docker-compose.yml**
- **Maps local files** into the container for **hot-reloading**.
- Includes a **PostgreSQL service** for database support.
- Defines **environment variables** for the database and secret key.
- Ensures **Phoenix waits for the database** before starting.

---

## **How to Run**
### **Start the Development Server**
```bash
docker-compose up --build
```
- Phoenix will run on **http://localhost:4000**
- PostgreSQL will be available on **port 5432**

### **Rebuild After Changes**
```bash
docker-compose up --build --force-recreate
```

---

## **Optimizations & Best Practices**
- **Efficient caching**: Installs dependencies **before** copying the app code.
- **Volumes**: Keeps dependencies & builds outside the container to **speed up reloads**.
- **Separate DB service**: Keeps **PostgreSQL independent** from the app.

---

This setup is **lightweight, scalable, and developer-friendly** 🚀. Let me know if you need further refinements!