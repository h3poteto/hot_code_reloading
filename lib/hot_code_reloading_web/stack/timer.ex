defmodule HotCodeReloadingWeb.Stack.Timer do
  @vsn "1"

  alias HotCodeReloadingWeb.Stack.Stack
  require Logger
  use GenServer

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    random = :rand.uniform(10)

    if random >= 8 do
      value = Stack.pop()
      Logger.debug("Stack poped #{value}")
    else
      random
      |> Stack.push()

      Logger.debug("Stack pushed #{inspect(Stack.stack())}")
    end

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 5 * 1000)
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end
end
