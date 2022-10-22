defmodule Zapp.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zapp.Accounts.User

  schema "accounts" do
    has_many :users, User
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [])
    |> validate_required([])
  end
end
