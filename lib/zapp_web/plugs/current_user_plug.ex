defmodule ZappWeb.Plugs.CurrentUserPlug do
  import Plug.Conn
  alias Zapp.Accounts

  def init(options) do
    options
  end

  def call(conn, _opts) do
    identity = conn.assigns[:current_identity]
    if identity do
      user = Accounts.get_user_with_account_by_identity!(identity)

      conn
      |> assign(:current_user, user)
      |> assign(:current_account, user.account)
    else
      conn
    end
  end
end


