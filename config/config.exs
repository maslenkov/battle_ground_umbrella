# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :battle_ground_web,
  generators: [context_app: :battle_ground]

# Configures the endpoint
config :battle_ground_web, BattleGroundWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "okcr4GHnKi0MKYwOc1Scp32EEDDwoO8A1DsGONvX4XbxSaZRozVFanr5CBGlbaDn",
  render_errors: [view: BattleGroundWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BattleGroundWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
