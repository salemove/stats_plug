defmodule Plug.StatsTest do
  use ExUnit.Case

  import Plug.Conn
  import Phoenix.ConnTest
  import Mox

  alias Plug.Stats.MetricsMock

  setup :verify_on_exit!

  test "emits configured metrics with a set of tags" do
    expect(MetricsMock, :histogram, fn "web.request", elapsed, opts ->
      assert elapsed > 0
      assert "http_method:post" in opts[:tags]
      assert "http_status:200" in opts[:tags]
      assert "http_status_class:2xx" in opts[:tags]
    end)

    conn =
      build_conn(:post, "/resource")
      |> put_private(:phoenix_action, :create)
      |> put_private(:phoenix_controller, Plug.Stats.DummyController)
      |> Plug.Stats.call(backend: MetricsMock, metric_name: "web.request")

    # Simulate request processing.
    Process.sleep(1)

    send_resp(conn, 200, "Response OK")
  end

  test "doesn't emit anything if request didn't reach Phoenix" do
    conn =
      build_conn()
      |> Plug.Stats.call(backend: MetricsMock, metric_name: "web.request")

    send_resp(conn, 200, "Response OK")
  end
end
