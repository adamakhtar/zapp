defmodule Zapp.Repo.Migrations.ChangeBodyToTextColumnOnTextSections do
  use Ecto.Migration

  def change do
    alter table("text_sections") do
      modify :body, :text, from: :string
    end
  end
end
