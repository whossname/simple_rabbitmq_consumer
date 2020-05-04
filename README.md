# Simple RabbitMQ Consumer

Handles all disconnection/reconnection concerns. Assumes the incoming messages are JSON and uses the Jason library to parse incomming messages.

## Usage

The module is a GenServer used as follows:

```elixir
  opts = %{
    connection: [
      host: "127.0.0.1",
      port: 5672,
      username: "user",
      password: "password"
    ],
    topic: "test-topic",
    handle_payload: fn msg ->
      Reciever.send(msg)
    end
  }

  SimpleRabbitMQConsumer.start_link(opts)
```

You might want to add this GenServer to your supervision tree as follows:

```elixir
defmodule YourApp.Application do
  use Application

  def start(_type, _args) do
    rabbitmq_opts = %{
      connection: [
        host: "127.0.0.1",
        port: 5672,
        username: "user",
        password: "password"
      ],
      topic: "test-topic",
      handle_payload: fn msg ->
        YourApp.send(msg)
      end
    }

    children = [{SimpleRabbitMQConsumer, rabbitmq_opts}]
    opts = [strategy: :one_for_all, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end

```

## Installation

The package can be installed by adding `simple_rabbitmq_consumer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_rabbitmq_consumer, "~> 0.1.0"}
  ]
end
```
