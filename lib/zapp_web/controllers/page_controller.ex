defmodule ZappWeb.PageController do
  use ZappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
