defmodule ZappWeb.IdentitySessionController do
  use ZappWeb, :controller

  alias Zapp.Accounts
  alias ZappWeb.IdentityAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"identity" => identity_params}) do
    %{"email" => email, "password" => password} = identity_params

    if identity = Accounts.get_identity_by_email_and_password(email, password) do
      IdentityAuth.log_in_identity(conn, identity, identity_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> IdentityAuth.log_out_identity()
  end
end
