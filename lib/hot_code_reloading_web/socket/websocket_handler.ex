defmodule HotCodeReloadingWeb.Socket.WebSocketHandler do
  @behaviour :cowboy_websocket

  require Logger

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    Logger.info("started websocket connection")
    {:ok, state}
  end

  def websocket_handle(:ping, state) do
    {:reply, :pong, state}
  end

  def websocket_handle({:text, message}, state) do
    Logger.debug("recived message: #{message}")
    {:reply, {:text, message}, state}
  end

  def websocket_info(_info, state), do: {[], state}

  def terminate(_reason, _req, _state) do
    Logger.info("terminated")
    :ok
  end
end
