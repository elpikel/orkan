defmodule Orkan.Application do
  use Application

  def start(_type, _args) do
    children = [
      Orkan.Repo,
      {Phoenix.PubSub, name: Orkan.PubSub},
      OrkanWeb.Endpoint,
      Orkan.Scheduler
    ]

    opts = [strategy: :one_for_one, name: Orkan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    OrkanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
