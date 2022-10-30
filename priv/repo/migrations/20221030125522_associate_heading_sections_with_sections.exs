defmodule Zapp.Repo.Migrations.AssociateHeadingSectionsWithSections do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :heading_section_id, references(:heading_sections, on_delete: :nothing)
    end
  end
end
