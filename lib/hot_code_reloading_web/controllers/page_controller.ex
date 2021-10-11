defmodule HotCodeReloadingWeb.PageController do
  use HotCodeReloadingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
