defmodule ZappWeb.LiveAuth do
  import Phoenix.LiveView
  alias Zapp.Accounts
  alias Zapp.Accounts.{Identity}
  alias ZappWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, session, socket) do
    socket = assign_current_identity(socket, session)

    case socket.assigns.current_identity do
      nil ->
        {:halt,
          socket
          |> put_flash(:error, "You have to sign in to continue")
          |> redirect(to: Routes.identity_session_path(socket, :new))
        }
      %Identity{} ->
        socket = assign_current_user_and_account(socket)
        {:cont, socket}
    end
  end

  defp assign_current_identity(socket, session) do
    case session do
      %{"identity_token" => identity_token} ->
        assign_new(socket, :current_identity, fn ->
          Accounts.get_identity_by_session_token(identity_token)
        end)
      %{} ->
        assign_new(socket, :current_identity, fn -> nil end)
    end
  end

  defp assign_current_user_and_account(socket) do
    socket
    |> assign_new(:current_user, fn ->
        Accounts.get_user_with_account_by_identity!(socket.assigns.current_identity)
      end)
    |> assign_new(:current_account, fn %{current_user: current_user} -> current_user.account end)
  end
end
