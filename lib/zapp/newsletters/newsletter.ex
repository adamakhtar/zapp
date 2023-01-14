defmodule Zapp.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "newsletters" do
    field :name, :string
    field :account_id, :id
    field :subdomain, :string

    timestamps()
  end

  @doc false
  def changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :account_id, :subdomain])
    |> validate_required([:name, :account_id, :subdomain])
    |> unique_constraint(:subdomain,
        name: :newsletters_subdomain_index,
        message: "is already taken")

  end
end
