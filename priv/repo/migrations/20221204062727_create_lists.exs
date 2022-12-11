defmodule Zapp.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name, :string
      add :twitter_id, :bigint
      add :account_id, references(:accounts, on_delete: :nothing)
      add :newsletter_id, references(:newsletters, on_delete: :nothing)

      timestamps()
    end

    create index(:lists, [:account_id])
    create index(:lists, [:newsletter_id])
  end
end
