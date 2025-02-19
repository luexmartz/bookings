# Use an official Elixir image that includes Erlang
FROM elixir:1.18.2

# Install Hex & Rebar (Elixir build tools)
RUN mix local.hex --force && \
    mix local.rebar --force

# Set environment variables
ENV MIX_ENV=dev

# Create and set the working directory
WORKDIR /app

# Copy Elixir dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# Copy the project files
COPY . .

# Compile the project
RUN mix compile

# Expose the Phoenix server port
EXPOSE 4000

# Default command to start the app
CMD ["mix", "phx.server"]
