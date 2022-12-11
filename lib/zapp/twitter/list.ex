defmodule Zapp.Twitter.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string
    field :twitter_id, :integer
    field :account_id, :id
    field :newsletter_id, :id

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name, :twitter_id, :account_id, :newsletter_id])
    |> validate_required([:name, :twitter_id, :account_id, :newsletter_id])
  end
end
