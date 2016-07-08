# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :preload_limit_order_association,
  ecto_repos: [PreloadLimitOrderAssociation.Repo]

# Configures the endpoint
config :preload_limit_order_association, PreloadLimitOrderAssociation.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "unxQjHsdLGJMqqgBTkK81gVZG6L09GM9lnRv2AP2cFzuMRhHhXk3d5f7+gpKqhAQ",
  render_errors: [view: PreloadLimitOrderAssociation.ErrorView, accepts: ~w(json)],
  pubsub: [name: PreloadLimitOrderAssociation.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
