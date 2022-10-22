defmodule Zapp.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :title, :string
      add :account_id, references(:accounts, on_delete: :nothing)
      add :newsletter_id, references(:newsletters, on_delete: :nothing)

      timestamps()
    end

    create index(:issues, [:account_id])
    create index(:issues, [:newsletter_id])
  end
end
