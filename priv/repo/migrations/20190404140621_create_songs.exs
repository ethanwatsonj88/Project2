defmodule Project2.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :name, :string

      timestamps()
    end

  end
end
