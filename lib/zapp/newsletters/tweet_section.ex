defmodule Zapp.Newsletters.TweetSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.Section

  # TODO: add account id
  schema "tweet_sections" do
    field :body, :string
    has_one :section, Section

    timestamps()
  end

  @doc false
  def changeset(tweet_section, attrs) do
    tweet_section
    |> cast(attrs, [:body])
    |> cast_assoc(:section)
    |> validate_required([:body])
  end
end
