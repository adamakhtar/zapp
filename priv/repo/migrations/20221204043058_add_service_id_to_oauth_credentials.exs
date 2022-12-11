defmodule Zapp.Repo.Migrations.AddServiceIdToOauthCredentials do
  use Ecto.Migration

  def change do
    alter table(:oauth_credentials) do
      add :service_id, :string
    end
  end
end
