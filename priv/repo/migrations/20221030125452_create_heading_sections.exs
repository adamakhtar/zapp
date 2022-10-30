defmodule Zapp.Repo.Migrations.CreateHeadingSections do
  use Ecto.Migration

  def change do
    create table(:heading_sections) do
      add :title, :string

      timestamps()
    end
  end
end
