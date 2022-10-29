defmodule Zapp.Newsletters.Section do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoRanked

  alias Zapp.Newsletters.{Issue, TweetSection}


  schema "sections" do
    field :rank, :integer
    belongs_to :issue, Issue
    belongs_to :tweet_section, TweetSection
    field :position, :any, virtual: true # used by EctoRanked

    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:position, :issue_id])
    |> validate_required([:position, :issue_id])
    |> set_rank(scope: :issue_id, scope_required: true)
  end
end
