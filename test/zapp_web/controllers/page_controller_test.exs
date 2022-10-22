defmodule ZappWeb.PageControllerTest do
  use ZappWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Zapp"
  end
end
