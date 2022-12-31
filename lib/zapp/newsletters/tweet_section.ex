defmodule Zapp.Newsletters.TweetSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.{Section, TweetSectionMedia}

  # TODO: add account id
  schema "tweet_sections" do
    field :text, :string
    field :user_name, :string
    field :user_screen_name, :string
    field :user_profile_image_url, :string
    field :retweet_count, :integer
    field :favorite_count, :integer
    has_one :section, Section
    has_many :tweet_section_medias, TweetSectionMedia

    timestamps()
  end

  @doc false
  def changeset(tweet_section, attrs) do
    tweet_section
    |> cast(attrs, [:text, :user_name, :user_screen_name, :user_profile_image_url, :retweet_count, :favorite_count])
    |> cast_assoc(:section)
    |> cast_assoc(:tweet_section_medias, with: &TweetSectionMedia.cast_assoc_changeset/2)
    |> validate_required([:text, :user_name, :user_screen_name, :user_profile_image_url, :retweet_count, :favorite_count])
  end
end
