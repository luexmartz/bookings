defmodule Bookings.HttpClient do
  @moduledoc """
  HTTP client for requests.
  """

  require Logger

  alias __MODULE__

  @type method() :: :get | :post | :head | :patch | :delete | :options | :put | String.t()

  @type t :: %HttpClient{
          method: method(),
          url: String.t(),
          headers: [{String.t(), String.t()}],
          params: [{String.t(), String.t()}]
        }

  defstruct method: :get,
            url: "",
            headers: [],
            params: []

  @spec build_conn(atom(), method(), String.t()) :: t()
  def build_conn(app, method, path) do
    Logger.info("[request] #{String.upcase(Atom.to_string(method))} :#{app} #{path}")
    %HttpClient{method: method, url: get_url(app, path)}
  end

  @spec add_request_header(t(), String.t(), String.t()) :: t()
  def add_request_header(%HttpClient{} = conn, key, value) do
    %{conn | headers: [{key, value} | conn.headers]}
  end

  @spec add_request_parameters(t(), map()) :: t()
  def add_request_parameters(%HttpClient{} = conn, params) when is_map(params) do
    %{conn | params: Map.to_list(params)}
  end

  @spec add_request_parameters(t(), String.t(), String.t()) :: t()
  def add_request_parameters(%HttpClient{} = conn, key, value) do
    %{conn | params: [{key, value} | conn.params]}
  end

  @spec make_request(t()) :: {:ok, map()} | {:error, map()}
  def make_request(%HttpClient{
        method: method,
        url: url,
        headers: headers,
        params: params
      }) do
    url_with_params = URI.merge(url, "?" <> URI.encode_query(params))

    method
    |> Finch.build(url_with_params, headers)
    |> Finch.request(Bookings.Finch)
  end

  defp get_url(app, path) do
    url = Keyword.fetch!(Application.get_env(:bookings, app), :url)
    url <> path
  end
end
