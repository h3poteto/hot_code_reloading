defmodule HotCodeReloadingWeb.Stack.Supervisor do
  use Supervisor

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl Supervisor
  def init(_) do
    children = [
      {HotCodeReloadingWeb.Stack.Stack, []},
      {HotCodeReloadingWeb.Stack.Timer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
