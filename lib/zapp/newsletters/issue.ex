defmodule Zapp.Newsletters.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zapp.Newsletters.TweetSection

  schema "issues" do
    field :title, :string
    field :account_id, :id
    field :newsletter_id, :id

    has_many :tweet_sections, TweetSection

    timestamps()
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:title, :account_id, :newsletter_id])
    |> validate_required([:title, :account_id, :newsletter_id])
  end
end
