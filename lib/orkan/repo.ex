defmodule Orkan.Repo do
  use Ecto.Repo,
    otp_app: :orkan,
    adapter: Ecto.Adapters.Postgres
end
