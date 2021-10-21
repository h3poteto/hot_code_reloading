defmodule HotCodeReloadingWeb.Stack.Stack do
  @vsn "2"

  use GenServer
  require Logger

  defstruct [:stack, :last_insert_time]

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:pop, _from, %{stack: []} = state) do
    {:reply, nil, state}
  end

  @impl GenServer
  def handle_call(:pop, _from, %{stack: [head | tail], last_insert_time: time} = _state) do
    {:reply, head, %{stack: tail, last_insert_time: time}}
  end

  @impl GenServer
  def handle_call(:stack, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:push, item}, %{stack: stack} = _state) do
    {:noreply, %{stack: [item | stack], last_insert_time: DateTime.utc_now()}}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, %{stack: state, last_insert_time: nil}, name: __MODULE__)
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

  ## for hot code reloading
  @impl GenServer
  def code_change("1" = vsn, state, _extra) do
    Logger.info("Starting code change #{__MODULE__} from #{vsn}")

    case state do
      [head | _tail] -> {:ok, %{stack: [head], last_insert_time: nil}}
      _ -> {:ok, %{stack: state, last_insert_time: nil}}
    end
  end
end
