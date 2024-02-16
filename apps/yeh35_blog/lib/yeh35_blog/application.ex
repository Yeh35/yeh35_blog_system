defmodule Yeh35Blog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Yeh35BlogWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:yeh35_blog, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Yeh35Blog.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Yeh35Blog.Finch},
      # Start a worker by calling: Yeh35Blog.Worker.start_link(arg)
      # {Yeh35Blog.Worker, arg},
      # Start to serve requests, typically the last entry
      Yeh35BlogWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Yeh35Blog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Yeh35BlogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
