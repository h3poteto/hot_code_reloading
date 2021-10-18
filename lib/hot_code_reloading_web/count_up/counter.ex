defmodule HotCodeReloadingWeb.CountUp.Counter do
  @vsn "1"

  alias HotCodeReloadingWeb.CountUp.Counter

  use GenServer

  defstruct [:count]

  def init(state) do
    {:ok, state}
  end

  def handle_call(:increment, _from, %{count: number} = state) do
    next = number + 1
    {:reply, next, %{state | count: next}}
  end

  def handle_call(:current, _from, %{count: number} = state) do
    {:reply, number, state}
  end

  def start_link(init_number \\ 0) do
    GenServer.start_link(__MODULE__, %Counter{count: init_number}, name: __MODULE__)
  end

  def increment() do
    GenServer.call(__MODULE__, :increment)
  end

  def current() do
    GenServer.call(__MODULE__, :current)
  end
end
