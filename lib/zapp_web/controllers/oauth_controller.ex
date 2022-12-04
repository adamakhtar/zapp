# Used for connecting a user's twitter account via Twitter Oauth and Uberauth.

defmodule ZappWeb.OauthController do
  use ZappWeb, :controller
  plug Ueberauth

  alias Zapp.Accounts

  def callback(conn, _params) do
    case Accounts.connect_or_update_oauth_account(
      conn.assigns.current_user,
      %{
        token: conn.assigns.ueberauth_auth.credentials.token,
        secret: conn.assigns.ueberauth_auth.credentials.secret,
        reference: conn.assigns.ueberauth_auth.info.nickname
      }
    ) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Successfully connected your Twitter account.")
        |> redirect(to: "/" )

      {:error, _} ->
        conn
        |> put_flash(:info, "Sorry there was a problem connecting your Twitter account. Please try again.")
        |> redirect(to: "/" )
      end
  end
end
