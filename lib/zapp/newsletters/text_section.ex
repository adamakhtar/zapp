defmodule Zapp.Newsletters.TextSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.Section

  schema "text_sections" do
    field :body, :string
    has_one :section, Section

    timestamps()
  end

  @doc false
  def changeset(text_section, attrs) do
    text_section
    |> cast(attrs, [:body])
    |> cast_assoc(:section)
    |> validate_required([:body])
  end
end
