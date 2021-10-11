import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hot_code_reloading, HotCodeReloadingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "EJ0hWS3dHDbfAuAVWkre6puTpO+7r/2L5uLRMxHQi1ByrJet06eKWTRGSeClp/21",
  server: false

# In test we don't send emails.
config :hot_code_reloading, HotCodeReloading.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
