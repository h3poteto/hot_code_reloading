defmodule HotCodeReloadingWeb.Queue.Queue do
  @vsn "2"
  use GenServer
  require Logger

  def init(state) do
    {:ok, state}
  end

  def handle_call(:dequeue, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:dequeue, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call(:queue, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:enqueue, item}, state) do
    {:noreply, state ++ [item]}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def enqueue(value) do
    GenServer.cast(__MODULE__, {:enqueue, value})
  end

  def dequeue() do
    GenServer.call(__MODULE__, :dequeue)
  end

  def queue() do
    GenServer.call(__MODULE__, :queue)
  end

  ## for hot code reloading
  def code_change("1" = vsn, state, _extra) do
    Logger.info("Starting code change #{__MODULE__} from #{vsn}")

    case state do
      [head | _tail] -> {:ok, [head]}
      _ -> {:ok, state}
    end
  end
end
