defmodule Zapp.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "newsletters" do
    field :name, :string
    field :account_id, :id

    timestamps()
  end

  @doc false
  def changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :account_id])
    |> validate_required([:name, :account_id])
  end
end
