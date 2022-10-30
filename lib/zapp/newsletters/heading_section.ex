defmodule Zapp.Newsletters.HeadingSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.Section

  schema "heading_sections" do
    field :title, :string
    has_one :section, Section

    timestamps()
  end

  @doc false
  def changeset(heading_section, attrs) do
    heading_section
    |> cast(attrs, [:title])
    |> cast_assoc(:section)
    |> validate_required([:title])
  end
end
