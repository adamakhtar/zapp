defmodule Zapp.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :position, :integer, null: false
      add :issue_id, references(:issues, on_delete: :nothing)
      add :tweet_section_id, references(:tweet_sections, on_delete: :nothing)

      timestamps()
    end

    create index(:sections, [:issue_id])
    create index(:sections, [:tweet_section_id])
  end
end
