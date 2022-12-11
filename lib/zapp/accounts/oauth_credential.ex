defmodule Zapp.Accounts.OauthCredential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "oauth_credentials" do
    field :secret, :string
    field :token, :string
    field :reference, :string
    field :service_id, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(oauth_credential, attrs) do
    oauth_credential
    |> cast(attrs, [:token, :secret, :reference, :user_id, :service_id])
    |> validate_required([:token, :secret, :reference, :user_id, :service_id])
  end
end
