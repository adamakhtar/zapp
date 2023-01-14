defmodule Zapp.Repo.Migrations.AddSubdomainToNewsletters do
  use Ecto.Migration

  def change do
    alter table(:newsletters) do
      add :subdomain, :string, null: false
    end

    create unique_index(:newsletters, [:subdomain])
  end
end
