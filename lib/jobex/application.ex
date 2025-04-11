defmodule Jobex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JobexWeb.Telemetry,
      Jobex.Repo,
      {DNSCluster, query: Application.get_env(:jobex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jobex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Jobex.Finch},
      # Start a worker by calling: Jobex.Worker.start_link(arg)
      # {Jobex.Worker, arg},
      # Start to serve requests, typically the last entry
      JobexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jobex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JobexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
