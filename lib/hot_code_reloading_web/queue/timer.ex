defmodule HotCodeReloadingWeb.Queue.Timer do
  @vsn "1"

  alias HotCodeReloadingWeb.Queue
  require Logger
  use GenServer

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    Queue.Queue.enqueue(datetime)

    q = Queue.Queue.queue()
    Logger.debug("Queue enqueued #{inspect(q)}")

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # In 5 Seconds
    Process.send_after(self(), :work, 5 * 1000)
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end
end
