defmodule Zapp.Newsletters.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zapp.Newsletters.Section

  schema "issues" do
    field :title, :string
    field :account_id, :id
    field :newsletter_id, :id

    has_many :sections, Section

    timestamps()
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:title, :account_id, :newsletter_id])
    |> validate_required([:title, :account_id, :newsletter_id])
  end
end
