defmodule Zapp.Repo.Migrations.AddUserFieldsToTweetSections do
  use Ecto.Migration

  def change do
    alter table(:tweet_sections) do
      add :user_name, :string
      add :user_screen_name, :string
      add :user_profile_image_url, :string
      add :retweet_count, :integer
      add :favorite_count, :integer
    end

    rename table(:tweet_sections), :body, to: :text
  end
end
