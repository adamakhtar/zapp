defmodule Zapp.Audience.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string
    field :newsletter_id, :id

    timestamps()
  end

  @doc false
  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [:email, :newsletter_id])
    |> validate_email()
  end

  def validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique([:newsletter_id, :email], Zapp.Repo, error_key: :email, message: "has already been registered for this newsletter")
    |> unique_constraint([:newsletter_id, :email], error_key: :email, message: "has already been registered for this newsletter")
  end

  def join_changeset_errors(changeset) do
    IO.inspect(["CHANGESET", changeset])
    fields_with_full_error_message = traverse_errors(changeset, fn changeset, field, {msg, opts} ->
      field
        |> to_string()
        |> String.capitalize()
        |> Kernel.<>" "
        |> Kernel.<>msg
    end)

    joined_full_error_messages = fields_with_full_error_message
      |> Enum.map(fn {field, msg} ->  msg end)
      |> Enum.join(". ")

    joined_full_error_messages
  end
end
