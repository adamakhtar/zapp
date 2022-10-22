defmodule Zapp.Accounts.IdentityNotifier do
  import Swoosh.Email

  alias Zapp.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Zapp", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(identity, url) do
    deliver(identity.email, "Confirmation instructions", """

    ==============================

    Hi #{identity.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a identity password.
  """
  def deliver_reset_password_instructions(identity, url) do
    deliver(identity.email, "Reset password instructions", """

    ==============================

    Hi #{identity.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a identity email.
  """
  def deliver_update_email_instructions(identity, url) do
    deliver(identity.email, "Update email instructions", """

    ==============================

    Hi #{identity.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
