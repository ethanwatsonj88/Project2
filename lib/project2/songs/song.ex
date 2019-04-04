defmodule Project2.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
