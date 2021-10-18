defmodule HotCodeReloadingWeb.CountDown.Counter do
  @vsn "1"

  use GenServer
  require Logger

  defstruct [:count]

  @impl GenServer
  def init(state \\ %{counter: 0}) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:decrement, _from, %{count: number} = state) do
    next = number - 1
    {:reply, next, %{state | count: next}}
  end

  @impl GenServer
  def handle_call(:current, _from, %{count: number} = state) do
    {:reply, number, state}
  end

  @impl GenServer
  def terminate(reason, _state) do
    Logger.debug("CountDown gen_server is terminated because #{reason}")
    reason
  end
end
