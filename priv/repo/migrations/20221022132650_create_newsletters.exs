defmodule Zapp.Repo.Migrations.CreateNewsletters do
  use Ecto.Migration

  def change do
    create table(:newsletters) do
      add :name, :string
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:newsletters, [:account_id])
  end
end
