defmodule Zapp.Newsletters.Section do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.{Issue, TweetSection}

  schema "sections" do
    field :position, :integer
    belongs_to :issue, Issue
    belongs_to :tweet_section, TweetSection

    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:position, :issue_id])
    |> validate_required([:position, :issue_id])
  end
end
