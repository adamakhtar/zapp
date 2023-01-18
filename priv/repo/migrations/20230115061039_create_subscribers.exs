defmodule Zapp.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :email, :string
      add :newsletter_id, references(:newsletters, on_delete: :nothing)

      timestamps()
    end

    create index(:subscribers, [:email])
    create unique_index(:subscribers, [:newsletter_id, :email])
  end
end
