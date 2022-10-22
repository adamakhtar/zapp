defmodule Zapp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :identity_id, references(:identities, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:users, [:identity_id])
  end
end
