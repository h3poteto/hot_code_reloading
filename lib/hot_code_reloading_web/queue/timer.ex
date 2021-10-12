defmodule HotCodeReloadingWeb.Queue.Timer do
  alias HotCodeReloadingWeb.Queue

  use GenServer

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    Queue.Queue.enqueue(datetime)

    Queue.Queue.queue()
    |> IO.inspect()

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
