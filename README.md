# Plug.Stats

This Plug is meant to help collect statistics about the time it takes your application to process
HTTP requests. It emits a value for the processing time after every processed HTTP request.

The backend needs to provide a `histogram` function that the Plug uses to send the metrics over. This
function's behavior is described in `WebRequestStats.Behaviours.Backend`.

The metric emitted is called "web.request" (configurable) and
contains the following tags:
 * `action` - Controller and action name, underscored (e.g. "queue_controller.show")
 * `http_method` - HTTP method in lower case
 * `http_status` - Response status code (200, 404 etc)
 * `http_status_class` - Response status class (2xx, 4xx etc)

## Installation

TODO: Need to be made available in Hex.

The package can be installed by adding `stats_plug` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stats_plug, "~> 0.1.0"}
  ]
end
```

TODO: Remove this paragraph once all is in place.
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/stats_plug](https://hexdocs.pm/stats_plug).
