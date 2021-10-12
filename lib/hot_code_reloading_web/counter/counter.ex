defmodule HotCodeReloadingWeb.Counter.Counter do
  alias HotCodeReloadingWeb.Counter.Counter

  use GenServer

  defstruct [:count]

  def init(state) do
    {:ok, state}
  end

  def handle_call(:increment, _from, %{count: number} = state) do
    next = number + 1
    {:reply, next, %{state | count: next}}
  end

  def handle_call(:decrement, _from, %{count: number} = state) do
    next = number - 1
    {:reply, next, %{state | count: next}}
  end

  def start_link(init_number \\ 0) do
    GenServer.start_link(__MODULE__, %Counter{count: init_number}, name: __MODULE__)
  end

  def increment() do
    GenServer.call(__MODULE__, :increment)
  end

  def decrement() do
    GenServer.call(__MODULE__, :decrement)
  end
end
