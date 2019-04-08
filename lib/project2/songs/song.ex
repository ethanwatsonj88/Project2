defmodule Project2.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :name, :string
		field :link, :string
    field :webLink, :string

		belongs_to :user, Project2.Users.User

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:name, :user_id, :link, :webLink])
    |> validate_required([:name, :user_id, :link, :webLink])
  end
end
