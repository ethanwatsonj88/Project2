defmodule Project2.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :username, :string
		
		has_many :songs, Project2.Songs.Song

		has_many :follows, Project2.Follows.Follow, foreign_key: :follower_id

##		many_to_many :follows, Project2.Users.User, join_through: "follows"
		

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :admin])
    |> validate_required([:email, :username, :admin, :songs, :follows])
  end
end
