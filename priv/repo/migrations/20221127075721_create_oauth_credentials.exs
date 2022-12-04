defmodule Zapp.Repo.Migrations.CreateOauthCredentials do
  use Ecto.Migration

  def change do
    create table(:oauth_credentials) do
      add :token, :string
      add :secret, :string
      add :reference, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:oauth_credentials, [:user_id])
  end
end
