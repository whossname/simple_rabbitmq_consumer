defmodule SimpleRabbitMQConsumerTest do
  use ExUnit.Case
  doctest SimpleRabbitMQConsumer

  @msg %{"msg" => "msg"}
  @payload Jason.encode!(@msg)

  # expected message:

  test "starts" do
    this = self()
    opts = %{
      connection: [
        host: "127.0.0.1",
        port: 5672,
        username: "user",
        password: "password"
      ],
      topic: "test-topic",
      handle_payload: fn msg ->
        send(this, msg)
      end
    }

    SimpleRabbitMQConsumer.start_link(opts)

    receive do
      value -> assert value == @msg
    end
  end
end
