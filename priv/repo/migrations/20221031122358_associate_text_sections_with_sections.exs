defmodule Zapp.Repo.Migrations.AssociateTextSectionsWithSections do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :text_section_id, references(:text_sections, on_delete: :nothing)
    end
  end
end
