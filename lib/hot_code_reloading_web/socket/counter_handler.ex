defmodule HotCodeReloadingWeb.Socket.CounterHandler do
  @behaviour :cowboy_websocket

  require Logger
  alias HotCodeReloadingWeb.CountDown.Counter

  defstruct [:counter]

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(_state) do
    Logger.info("started websocket connection")
    {:ok, pid} = GenServer.start_link(Counter, %Counter{count: 1000})
    {:ok, %{counter: pid}}
  end

  def websocket_handle(:ping, state) do
    {:reply, :pong, state}
  end

  def websocket_handle({:text, "start"}, state) do
    Logger.debug("start counter")
    Process.send_after(self(), :counter, 10 * 1000)
    {:reply, {:text, "started"}, state}
  end

  def websocket_handle({:text, message}, state) do
    Logger.debug("recived message: #{message}")
    {:reply, {:text, message}, state}
  end

  def websocket_info(:counter, %{counter: pid} = state) do
    GenServer.call(pid, :decrement)
    current = GenServer.call(pid, :current)
    Process.send_after(self(), :counter, 5 * 1000)
    {:reply, {:text, "#{current}"}, state}
  end

  def websocket_info(info, state) do
    Logger.warn("unknown info is recived #{info}")
    {[], state}
  end

  def terminate(reason, _req, %{counter: pid} = _state) do
    GenServer.stop(pid)
    Logger.info("terminated")
    IO.inspect(reason)
    :ok
  end

  def terminate(reason, _req, _state) do
    Logger.info("terminated")
    IO.inspect(reason)
    :ok
  end
end
