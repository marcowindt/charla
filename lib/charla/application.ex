defmodule Charla.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Charla.Repo,
      # Start the Telemetry supervisor
      CharlaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Charla.PubSub},
      # Presence
      Charla.Presence,
      # Start the Endpoint (http/https)
      CharlaWeb.Endpoint
      # Start a worker by calling: Charla.Worker.start_link(arg)
      # {Charla.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Charla.Supervisor]
    result = Supervisor.start_link(children, opts)

    Charla.Release.migrate()

    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CharlaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
