defmodule Zapp.Repo.Migrations.RenamePositionToRankOnSections do
  use Ecto.Migration

  def change do
    rename table("sections"), :position, to: :rank
  end
end
