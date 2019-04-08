defmodule Project2Web.PageController do
  use Project2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def listener(conn, %{"listener" => listener}) do
    render(conn, "listener.html", listener: listener)
  end
end
