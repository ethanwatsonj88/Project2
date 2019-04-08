defmodule Project2.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :name, :string, null: false
			add :link, :string, null: false
      add :webLink, :string, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

  end
end
