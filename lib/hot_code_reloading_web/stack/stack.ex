defmodule HotCodeReloadingWeb.Stack.Stack do
  @vsn "1"

  use GenServer

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  @impl GenServer
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl GenServer
  def handle_call(:stack, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  def stack() do
    GenServer.call(__MODULE__, :stack)
  end
end
