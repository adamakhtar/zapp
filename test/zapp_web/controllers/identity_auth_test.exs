defmodule ZappWeb.IdentityAuthTest do
  use ZappWeb.ConnCase, async: true

  alias Zapp.Accounts
  alias ZappWeb.IdentityAuth
  import Zapp.AccountsFixtures

  @remember_me_cookie "_zapp_web_identity_remember_me"

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, ZappWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{identity: identity_fixture(), conn: conn}
  end

  describe "log_in_identity/3" do
    test "stores the identity token in the session", %{conn: conn, identity: identity} do
      conn = IdentityAuth.log_in_identity(conn, identity)
      assert token = get_session(conn, :identity_token)
      assert get_session(conn, :live_socket_id) == "identities_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == "/"
      assert Accounts.get_identity_by_session_token(token)
    end

    test "clears everything previously stored in the session", %{conn: conn, identity: identity} do
      conn = conn |> put_session(:to_be_removed, "value") |> IdentityAuth.log_in_identity(identity)
      refute get_session(conn, :to_be_removed)
    end

    test "redirects to the configured path", %{conn: conn, identity: identity} do
      conn = conn |> put_session(:identity_return_to, "/hello") |> IdentityAuth.log_in_identity(identity)
      assert redirected_to(conn) == "/hello"
    end

    test "writes a cookie if remember_me is configured", %{conn: conn, identity: identity} do
      conn = conn |> fetch_cookies() |> IdentityAuth.log_in_identity(identity, %{"remember_me" => "true"})
      assert get_session(conn, :identity_token) == conn.cookies[@remember_me_cookie]

      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies[@remember_me_cookie]
      assert signed_token != get_session(conn, :identity_token)
      assert max_age == 5_184_000
    end
  end

  describe "logout_identity/1" do
    test "erases session and cookies", %{conn: conn, identity: identity} do
      identity_token = Accounts.generate_identity_session_token(identity)

      conn =
        conn
        |> put_session(:identity_token, identity_token)
        |> put_req_cookie(@remember_me_cookie, identity_token)
        |> fetch_cookies()
        |> IdentityAuth.log_out_identity()

      refute get_session(conn, :identity_token)
      refute conn.cookies[@remember_me_cookie]
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == "/"
      refute Accounts.get_identity_by_session_token(identity_token)
    end

    test "broadcasts to the given live_socket_id", %{conn: conn} do
      live_socket_id = "identities_sessions:abcdef-token"
      ZappWeb.Endpoint.subscribe(live_socket_id)

      conn
      |> put_session(:live_socket_id, live_socket_id)
      |> IdentityAuth.log_out_identity()

      assert_receive %Phoenix.Socket.Broadcast{event: "disconnect", topic: ^live_socket_id}
    end

    test "works even if identity is already logged out", %{conn: conn} do
      conn = conn |> fetch_cookies() |> IdentityAuth.log_out_identity()
      refute get_session(conn, :identity_token)
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == "/"
    end
  end

  describe "fetch_current_identity/2" do
    test "authenticates identity from session", %{conn: conn, identity: identity} do
      identity_token = Accounts.generate_identity_session_token(identity)
      conn = conn |> put_session(:identity_token, identity_token) |> IdentityAuth.fetch_current_identity([])
      assert conn.assigns.current_identity.id == identity.id
    end

    test "authenticates identity from cookies", %{conn: conn, identity: identity} do
      logged_in_conn =
        conn |> fetch_cookies() |> IdentityAuth.log_in_identity(identity, %{"remember_me" => "true"})

      identity_token = logged_in_conn.cookies[@remember_me_cookie]
      %{value: signed_token} = logged_in_conn.resp_cookies[@remember_me_cookie]

      conn =
        conn
        |> put_req_cookie(@remember_me_cookie, signed_token)
        |> IdentityAuth.fetch_current_identity([])

      assert get_session(conn, :identity_token) == identity_token
      assert conn.assigns.current_identity.id == identity.id
    end

    test "does not authenticate if data is missing", %{conn: conn, identity: identity} do
      _ = Accounts.generate_identity_session_token(identity)
      conn = IdentityAuth.fetch_current_identity(conn, [])
      refute get_session(conn, :identity_token)
      refute conn.assigns.current_identity
    end
  end

  describe "redirect_if_identity_is_authenticated/2" do
    test "redirects if identity is authenticated", %{conn: conn, identity: identity} do
      conn = conn |> assign(:current_identity, identity) |> IdentityAuth.redirect_if_identity_is_authenticated([])
      assert conn.halted
      assert redirected_to(conn) == "/"
    end

    test "does not redirect if identity is not authenticated", %{conn: conn} do
      conn = IdentityAuth.redirect_if_identity_is_authenticated(conn, [])
      refute conn.halted
      refute conn.status
    end
  end

  describe "require_authenticated_identity/2" do
    test "redirects if identity is not authenticated", %{conn: conn} do
      conn = conn |> fetch_flash() |> IdentityAuth.require_authenticated_identity([])
      assert conn.halted
      assert redirected_to(conn) == Routes.identity_session_path(conn, :new)
      assert get_flash(conn, :error) == "You must log in to access this page."
    end

    test "stores the path to redirect to on GET", %{conn: conn} do
      halted_conn =
        %{conn | path_info: ["foo"], query_string: ""}
        |> fetch_flash()
        |> IdentityAuth.require_authenticated_identity([])

      assert halted_conn.halted
      assert get_session(halted_conn, :identity_return_to) == "/foo"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar=baz"}
        |> fetch_flash()
        |> IdentityAuth.require_authenticated_identity([])

      assert halted_conn.halted
      assert get_session(halted_conn, :identity_return_to) == "/foo?bar=baz"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar", method: "POST"}
        |> fetch_flash()
        |> IdentityAuth.require_authenticated_identity([])

      assert halted_conn.halted
      refute get_session(halted_conn, :identity_return_to)
    end

    test "does not redirect if identity is authenticated", %{conn: conn, identity: identity} do
      conn = conn |> assign(:current_identity, identity) |> IdentityAuth.require_authenticated_identity([])
      refute conn.halted
      refute conn.status
    end
  end
end
