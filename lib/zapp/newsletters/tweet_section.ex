defmodule Zapp.Newsletters.TweetSection do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO: add account id
  schema "tweet_sections" do
    field :body, :string
    field :issue_id, :id

    timestamps()
  end

  @doc false
  def changeset(tweet_section, attrs) do
    tweet_section
    |> cast(attrs, [:body, :issue_id])
    |> validate_required([:body, :issue_id])
  end
end
