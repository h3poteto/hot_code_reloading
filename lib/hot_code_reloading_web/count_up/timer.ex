defmodule HotCodeReloadingWeb.CountUp.Timer do
  @vsn "1"

  alias HotCodeReloadingWeb.CountUp.Counter
  alias HotCodeReloadingWeb.CountUp.Timer
  require Logger
  use GenServer

  defstruct [:counter]

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    count = Counter.increment()
    Logger.debug("Count up #{count}")

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # In 5 Seconds
    Process.send_after(self(), :work, 5 * 1000)
  end

  def start_link(_) do
    {:ok, pid} = Counter.start_link()
    GenServer.start_link(__MODULE__, %Timer{counter: pid}, name: __MODULE__)
  end
end
