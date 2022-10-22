import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :zapp, Zapp.Repo,
  username: "adamakhtar",
  password: "",
  hostname: "localhost",
  database: "zapp_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zapp, ZappWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OujVHYJhaVDGj38vWgHvGBARWVP1lB06AKlEPVfbs7IftQTzfg08Gi8SDnCts9TA",
  server: false

# In test we don't send emails.
config :zapp, Zapp.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :wallaby, otp_app: ZappWeb.Endpoint, server: true

config :wallaby, driver: Wallaby.Chrome

config :wallaby, :chromedriver, path: "/Users/adamakhtar/.webdrivers/chromedriver"

config :zapp, :sandbox, Ecto.Adapters.SQL.Sandbox