defmodule Zapp.Repo.Migrations.AssociateTweetSectionsWithSections do
  use Ecto.Migration

  def up do
    alter table(:tweet_sections) do
      remove :issue_id
    end
  end

  def down do
    alter table(:tweet_sections) do
      add :issue_id, references(:issues)
    end
  end
end
