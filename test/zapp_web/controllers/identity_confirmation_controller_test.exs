defmodule ZappWeb.IdentityConfirmationControllerTest do
  use ZappWeb.ConnCase, async: true

  alias Zapp.Accounts
  alias Zapp.Repo
  import Zapp.AccountsFixtures

  setup do
    {:ok, %{identity: identity}} = owner_and_account_fixture()
    %{identity: identity}
  end

  describe "GET /identities/confirm" do
    test "renders the resend confirmation page", %{conn: conn} do
      conn = get(conn, Routes.identity_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Resend confirmation instructions</h1>"
    end
  end

  describe "POST /identities/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, identity: identity} do
      conn =
        post(conn, Routes.identity_confirmation_path(conn, :create), %{
          "identity" => %{"email" => identity.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(Accounts.IdentityToken, identity_id: identity.id).context == "confirm"
    end

    test "does not send confirmation token if Identity is confirmed", %{conn: conn, identity: identity} do
      Repo.update!(Accounts.Identity.confirm_changeset(identity))

      conn =
        post(conn, Routes.identity_confirmation_path(conn, :create), %{
          "identity" => %{"email" => identity.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      refute Repo.get_by(Accounts.IdentityToken, identity_id: identity.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.identity_confirmation_path(conn, :create), %{
          "identity" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(Accounts.IdentityToken) == []
    end
  end

  describe "GET /identities/confirm/:token" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.identity_confirmation_path(conn, :edit, "some-token"))
      response = html_response(conn, 200)
      assert response =~ "<h1>Confirm account</h1>"

      form_action = Routes.identity_confirmation_path(conn, :update, "some-token")
      assert response =~ "action=\"#{form_action}\""
    end
  end

  describe "POST /identities/confirm/:token" do
    test "confirms the given token once", %{conn: conn, identity: identity} do
      token =
        extract_identity_token(fn url ->
          Accounts.deliver_identity_confirmation_instructions(identity, url)
        end)

      conn = post(conn, Routes.identity_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Identity confirmed successfully"
      assert Accounts.get_identity!(identity.id).confirmed_at
      refute get_session(conn, :identity_token)
      assert Repo.all(Accounts.IdentityToken) == []

      # When not logged in
      conn = post(conn, Routes.identity_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Identity confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_identity(identity)
        |> post(Routes.identity_confirmation_path(conn, :update, token))

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, identity: identity} do
      conn = post(conn, Routes.identity_confirmation_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Identity confirmation link is invalid or it has expired"
      refute Accounts.get_identity!(identity.id).confirmed_at
    end
  end
end
