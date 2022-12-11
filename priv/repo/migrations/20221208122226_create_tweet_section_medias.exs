defmodule Zapp.Repo.Migrations.CreateTweetSectionMedias do
  use Ecto.Migration

  def change do
    create table(:tweet_section_medias) do
      add :url, :string
      add :thumbnail_url, :string
      add :tweet_section_id, references(:tweet_sections, on_delete: :nothing)

      timestamps()
    end

    create index(:tweet_section_medias, [:tweet_section_id])
  end
end
