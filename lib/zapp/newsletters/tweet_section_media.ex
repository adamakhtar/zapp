defmodule Zapp.Newsletters.TweetSectionMedia do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.TweetSection

  schema "tweet_section_medias" do
    field :thumbnail_url, :string
    field :url, :string
    belongs_to :tweet_section, TweetSection

    timestamps()
  end

  @doc false
  def changeset(tweet_section_media, attrs) do
    tweet_section_media
    |> cast(attrs, [:url, :thumbnail_url, :tweet_section_id])
    |> validate_required([:url, :thumbnail_url, :tweet_section_id])
  end
end
