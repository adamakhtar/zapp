defmodule ZappWeb.IdentityAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Zapp.Accounts
  alias ZappWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in IdentityToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_zapp_web_identity_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the identity in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_identity(conn, identity, params \\ %{}) do
    token = Accounts.generate_identity_session_token(identity)
    identity_return_to = get_session(conn, :identity_return_to)

    conn
    |> renew_session()
    |> put_session(:identity_token, token)
    |> put_session(:live_socket_id, "identities_sessions:#{Base.url_encode64(token)}")
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: identity_return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the identity out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_identity(conn) do
    identity_token = get_session(conn, :identity_token)
    identity_token && Accounts.delete_session_token(identity_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      ZappWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the identity by looking into the session
  and remember me token.
  """
  def fetch_current_identity(conn, _opts) do
    {identity_token, conn} = ensure_identity_token(conn)
    identity = identity_token && Accounts.get_identity_by_session_token(identity_token)
    assign(conn, :current_identity, identity)
  end

  defp ensure_identity_token(conn) do
    if identity_token = get_session(conn, :identity_token) do
      {identity_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if identity_token = conn.cookies[@remember_me_cookie] do
        {identity_token, put_session(conn, :identity_token, identity_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the identity to not be authenticated.
  """
  def redirect_if_identity_is_authenticated(conn, _opts) do
    if conn.assigns[:current_identity] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the identity to be authenticated.

  If you want to enforce the identity email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_identity(conn, _opts) do
    if conn.assigns[:current_identity] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.identity_session_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :identity_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: "/"
end
