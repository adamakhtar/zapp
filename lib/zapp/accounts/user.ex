defmodule Zapp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Accounts.{Identity, Account, OauthCredential}

  schema "users" do
    belongs_to :identity, Identity
    belongs_to :account, Account
    has_one :oauth_credential, OauthCredential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:identity_id, :account_id])
    |> validate_required([:identity_id, :account_id])
    |> unique_constraint(:identity_id)
  end
end
