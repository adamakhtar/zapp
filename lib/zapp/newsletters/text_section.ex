defmodule Zapp.Newsletters.TextSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Newsletters.Section
  alias HtmlSanitizeEx

  schema "text_sections" do
    field :body, :string
    has_one :section, Section

    timestamps()
  end

  @doc false
  def changeset(text_section, attrs) do
    # TODO - SECURITY test scrubbing!
    scrubbed_attrs = Map.put(attrs, :body, scrub_html(attrs[:body]))

    text_section
    |> cast(attrs, [:body])
    |> cast_assoc(:section)
    |> validate_required([:body])
  end

  def scrub_html(nil) do
    nil
  end

  def scrub_html(html) do
    HtmlSanitizeEx.basic_html(html)
  end
end
