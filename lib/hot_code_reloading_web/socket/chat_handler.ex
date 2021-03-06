defmodule HotCodeReloadingWeb.Socket.ChatHandler do
  @vsn "1"

  @behaviour :cowboy_websocket
  alias HotCodeReloadingWeb.Socket.ChatHandler

  require Logger
  defstruct [:username]

  @topic inspect(__MODULE__)

  def init(%{headers: %{"sec-websocket-protocol" => username}} = req, _state) do
    {:cowboy_websocket, req, %ChatHandler{username: username}}
  end

  def websocket_init(%{username: username} = state) do
    Logger.info("start chat connection from #{username}")
    :ok = Phoenix.PubSub.subscribe(HotCodeReloading.PubSub, @topic)
    {:ok, state}
  end

  def websocket_handler(:ping, state) do
    {:reply, :pong, state}
  end

  def websocket_handle({:text, "ping"}, state) do
    {:reply, {:text, "pong"}, state}
  end

  def websocket_handle({:text, message}, %{username: username} = state) do
    now = DateTime.utc_now()

    {:ok, _} =
      broadcast(
        "#{message} from #{username} at #{now.year}/#{now.month}/#{now.day} #{now.hour}:#{now.minute}:#{now.second}",
        now
      )

    send(self(), :external_service)

    {:ok, state}
  end

  def websocket_info({:broadcast, message}, state) do
    {:reply, {:text, message}, state}
  end

  def websocket_info(:external_service, state) do
    case HTTPoison.get("https://whalebird.social") do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Logger.info("Success to get external service")

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("Not found")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(inspect(reason))
    end

    {:ok, state}
  end

  def websocket_info(info, state) do
    Logger.warn("unknown info is recived #{info}")
    {:ok, state}
  end

  def terminate(reason, _req, _state) do
    Logger.info("terminated")
    IO.inspect(reason)
    :ok
  end

  def handle_info({:broadcast, message}, state) do
    send(self(), {:broadcast, message})

    {:noreply, state}
  end

  def broadcast(message, timestamp) do
    Logger.debug("Message is broadcasted at #{inspect(timestamp)}")
    Phoenix.PubSub.broadcast(HotCodeReloading.PubSub, @topic, {:broadcast, message})
    {:ok, message}
  end
end
