defmodule SimpleRabbitMQConsumer do
  use GenServer
  require Logger

  @reconnect_interval 10_000

  def start_link(opts) do
    Logger.debug("Started SimpleRabbitMQConsumer")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    send(self(), :connect)
    state = Map.put(opts, :prev, nil)
    {:ok, state}
  end

  def handle_info(:connect, state) do
    case connect(state) do
      {:ok, conn} ->
        Process.monitor(conn.pid)
        Logger.info("SimpleRabbitMQConsumer connected")
        {:noreply, state}

      _ ->
        Logger.error("SimpleRabbitMQConsumer Failed to connect. Reconnecting later...")
        Process.send_after(self(), :connect, @reconnect_interval)
        {:noreply, state}
    end
  end

  def handle_info({:DOWN, _, :process, _pid, reason}, state) do
    {:stop, {:connection_lost, reason}, state}
  end

  def handle_info({:payload, payload}, state) do
    if state.prev != payload do
      fun = state.handle_payload
      fun.(payload)
    end

    state = Map.put(state, :prev, payload)
    {:noreply, state}
  end

  defp new_message(payload, _) do
    payload = Jason.decode!(payload)
    send(__MODULE__, {:payload, payload})
  end

  defp connect(state) do
    with {:ok, conn} <- AMQP.Connection.open(state.connection),
         {:ok, chan} <- AMQP.Channel.open(conn),
         {:ok, _} <- AMQP.Queue.subscribe(chan, state.topic, &new_message/2) do
      {:ok, conn}
    else
      err -> err
    end
  end
end
