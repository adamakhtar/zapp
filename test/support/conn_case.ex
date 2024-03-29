defmodule ZappWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ZappWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ZappWeb.ConnCase

      alias ZappWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ZappWeb.Endpoint
    end
  end

  setup tags do
    Zapp.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in identities.

      setup :register_and_log_in_identity

  It stores an updated connection and a registered identity in the
  test context.
  """
  def register_and_log_in_identity(%{conn: conn}) do
    {:ok, %{identity: identity, account: account, user: user}} = Zapp.AccountsFixtures.owner_and_account_fixture()
    %{conn: log_in_identity(conn, identity), identity: identity, account: account, user: user}
  end

  @doc """
  Logs the given `identity` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_identity(conn, identity) do
    token = Zapp.Accounts.generate_identity_session_token(identity)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:identity_token, token)
  end
end
