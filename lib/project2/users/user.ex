defmodule Project2.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :username, :string
		
		has_many :songs, Project2.Songs.Song

		has_many :followers, Project2.Users.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :admin, :songs, :followers])
    |> validate_required([:email, :username, :admin, :songs, :followers])
  end
end
