defmodule ZappWeb.CurrentUserPlug do
  use ExUnit.Case, async: true
  use Plug.Test
  use Zapp.DataCase
  alias ZappWeb.Plugs.CurrentUserPlug
  import Zapp.AccountsFixtures


  test "assigns user and account if authentiticated" do
    {:ok, %{identity: identity, user: user, account: account}} = owner_and_account_fixture()

    conn =
      conn(:get, "/")
      |> assign(:current_identity, identity)
      |> CurrentUserPlug.call(%{})

    assert conn.assigns[:current_user].identity_id == identity.id
    assert conn.assigns[:current_user].id == user.id
    assert conn.assigns[:current_account].id == account.id
  end

  test "does not assign user and account if unauthentiticated" do
    conn =
      conn(:get, "/")
      |> CurrentUserPlug.call(%{})

    assert conn.assigns[:current_user] == nil
    assert conn.assigns[:current_user] == nil
    assert conn.assigns[:current_account] == nil
  end
end
