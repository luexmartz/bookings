defmodule Bookings.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:bookings, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bookings.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bookings.Finch}
      # Start a worker by calling: Bookings.Worker.start_link(arg)
      # {Bookings.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Bookings.Supervisor)
  end
end
