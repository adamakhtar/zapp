defmodule Zapp.Repo.Migrations.CreateTextSections do
  use Ecto.Migration

  def change do
    create table(:text_sections) do
      add :body, :string

      timestamps()
    end
  end
end
