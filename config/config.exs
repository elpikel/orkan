import Config

config :orkan,
  ecto_repos: [Orkan.Repo]

config :orkan, OrkanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3Zql8GaA4zdWtwhLHbwzf+Zrg1WEeYekLfun8Krg06WrFtY4LB23m5+SfjmsXxZe",
  render_errors: [view: OrkanWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Orkan.PubSub,
  live_view: [signing_salt: "Y0jMEOCF"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :orkan, Orkan.Scheduler,
  jobs: [
    {"0 5 * * *", {Orkan.Forecasts.Worker, :update_forecasts, []}},
    {"1 7 * * *", {Orkan.Notifications.Worker, :send_forecasts, []}}
  ]

config :orkan, Orkan.Notifications.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

config :tesla, adapter: Tesla.Adapter.Hackney

import_config "#{Mix.env()}.exs"
