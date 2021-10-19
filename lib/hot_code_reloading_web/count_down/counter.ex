defmodule HotCodeReloadingWeb.CountDown.Counter do
  @vsn "2"

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

  ## for hot code reloading
  # This method will not be called when hot code reloading, because this module
  # is not a member of the application supervisor. This gen_server is not managed by
  # application supervisor, this gen_server is managed by websocket handler.
  def code_change("1" = vsn, state, _extra) do
    Logger.info("Starting code change from #{__MODULE__} from #{vsn}")
    %{count: count} = state
    {:ok, %{count: count + 10_000}}
  end
end
