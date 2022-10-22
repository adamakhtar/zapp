defmodule ZappWeb.IdentityRegistrationController do
  use ZappWeb, :controller

  alias Zapp.Accounts
  alias Zapp.Accounts.Identity
  alias ZappWeb.IdentityAuth

  def new(conn, _params) do
    changeset = Accounts.change_identity_registration(%Identity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"identity" => identity_params}) do
    case Accounts.register_owner_with_account(identity_params) do
      {:ok, %{identity: identity}} ->
        {:ok, _} =
          Accounts.deliver_identity_confirmation_instructions(
            identity,
            &Routes.identity_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Identity created successfully.")
        |> IdentityAuth.log_in_identity(identity)
      {:error, :identity, %Ecto.Changeset{} = changeset, _} ->
        render(conn, "new.html", changeset: changeset)
      _ ->
        conn
        |> put_flash(:error, "Something went wrong. Please try again.")
        |> redirect(to: Routes.identity_registration_path(conn, :new))
    end
  end
end
