defmodule HotCodeReloadingWeb.Counter.Counter do
  @vsn "2.0"

  alias HotCodeReloadingWeb.Counter.Counter

  use GenServer

  defstruct [:count, :previous]

  def init(state) do
    {:ok, state}
  end

  def handle_call(:increment, _from, %{count: number} = state) do
    next = number + 1
    {:reply, {next, number}, %{state | count: next, previous: number}}
  end

  def handle_call(:decrement, _from, %{count: number} = state) do
    next = number - 1
    {:reply, {next, number}, %{state | count: next, previous: number}}
  end

  def handle_call(:current, _from, %{count: number, previous: previous} = state) do
    {:reply, {number, previous}, state}
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

  def current() do
    GenServer.call(__MODULE__, :current)
  end

  # Version up from 1.x to 2.x
  def code_change("1", %{counter: number}, _void) do
    {:ok, %{counter: number, previous: number}}
  end
end
