defmodule HotCodeReloadingWeb.CountUp.Counter do
  @vsn "2"

  alias HotCodeReloadingWeb.CountUp.Counter

  use GenServer
  require Logger
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

  ## for hot code reloading
  # This method will not be called when hot code reloading, because this module
  # is not a member of the application supervisor. This gen_server is not managed by
  # application supervisor, this gen_server is managed by another gen_server.
  def code_change("1" = vsn, state, _extra) do
    Logger.info("Starting code change #{__MODULE__} from #{vsn}")
    %{count: count} = state
    {:ok, %{state: count * 100}}
  end
end
