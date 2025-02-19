import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bookings_web, BookingsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "V37LmqKRpZBXyZ6mp/PQgN4x4BWBJ1yte0YtePwfe/QwrvOjtlme3E/zABWIOp6W",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails
config :bookings, Bookings.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :bookings,
       :airbnb,
       url: "http://localhost:4000"

config :bookings,
       :reservamos,
       url: "https://search.reservamos.mx/api/v2"
