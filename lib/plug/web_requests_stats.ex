defmodule WebRequestsStats do
  @moduledoc """
  This Plug emits metrics after every processed HTTP request.

  The metric emitted is called "web.request" (configurable) and
  contains the following tags:

    * `action` - Controller and action name, underscored (e.g. "queue_controller.show")
    * `http_method` - HTTP method in lower case
    * `http_status` - Response status code (200, 404 etc)
    * `http_status_class` - Response status class (2xx, 4xx etc)

  Emitted value is processing time in milliseconds.

  ## Configuration

  In `config/config.exs`:

    config :my_app, MyApp.Endpoint,
      stats: [
        backend: ExStatsD,
        metric_name: "web.request"
      ]

  """

  @behaviour Plug

  @default_config [
    backend: WebRequestStats.BackendProtocol,
    metric_name: "web.request"
  ]

  # import Plug.Conn

  @impl Plug
  def init(opts \\ []) do
    Keyword.merge(@default_config, opts)
  end

  @impl Plug
  def call(conn, opts) do
    start_time = System.monotonic_time()

    Plug.Conn.register_before_send(
      conn,
      fn conn ->
        stop_time = System.monotonic_time()
        elapsed_ms = native_to_milliseconds(stop_time - start_time)

        if processed_by_phoenix?(conn) do
          send_metric(conn, elapsed_ms, opts)
        end

        conn
      end
    )
  end

  defp send_metric(conn, elapsed_ms, config) do
    backend = config[:backend]
    metric_name = config[:metric_name]
    tags = calculate_tags(conn)

    backend.histogram(metric_name, elapsed_ms, tags: tags)
  end

  defp calculate_tags(conn) do
    [
      "action:#{action_name(conn)}",
      "http_method:#{String.downcase(conn.method)}",
      "http_status:#{conn.status}",
      "http_status_class:#{status_class(conn)}xx"
    ]
  end

  defp status_class(conn) do
    div(conn.status, 100)
  end

  defp action_name(conn) do
    # If the request has not reached the controller, the following values will be nil
    if conn.private[:phoenix_controller] == nil || conn.private[:phoenix_action] == nil do
      "unknown"
    else
      controller_name = Macro.underscore(conn.private[:phoenix_controller])
      action_name = conn.private[:phoenix_action]

      # Any initial string looking like "my_app_web/my_controller/index"
      # would result in "my_controller.index"
      "#{controller_name}/#{action_name}"
      |> String.split("/")
      |> Enum.drop(1)
      |> Enum.join("/")
      |> String.replace("/", ".")
    end
  end

  defp processed_by_phoenix?(conn) do
    conn.private[:phoenix_controller] && conn.private[:phoenix_action]
  end

  defp native_to_milliseconds(duration) do
    # convert_time_unit rounds the number using the floor function. To get
    # milliseconds with 3 decimal points we convert the duration to
    # microseconds and then divide it by a thousand.
    System.convert_time_unit(duration, :native, :microsecond) / 1000
  end
end
