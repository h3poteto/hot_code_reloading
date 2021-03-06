defmodule HotCodeReloading.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HotCodeReloadingWeb.CountUp.Timer,
      HotCodeReloadingWeb.Queue.Queue,
      HotCodeReloadingWeb.Queue.Timer,
      HotCodeReloadingWeb.Stack.Supervisor,
      # Start the Telemetry supervisor
      HotCodeReloadingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HotCodeReloading.PubSub},
      # Start the Endpoint (http/https)
      HotCodeReloadingWeb.Endpoint
      # Start a worker by calling: HotCodeReloading.Worker.start_link(arg)
      # {HotCodeReloading.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HotCodeReloading.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HotCodeReloadingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
