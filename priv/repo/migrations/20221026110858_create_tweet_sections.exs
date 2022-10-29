defmodule Zapp.Repo.Migrations.CreateTweetSections do
  use Ecto.Migration

  def change do
    create table(:tweet_sections) do
      add :body, :text
      add :issue_id, references(:issues, on_delete: :nothing)

      timestamps()
    end

    create index(:tweet_sections, [:issue_id])
  end
end
