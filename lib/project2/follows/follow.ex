defmodule Project2.Follows.Follow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Project2.Users.User
  alias Project2.Follows

  schema "follows" do
    ##field :follower_id, :id
    ##field :following_id, :id


		belongs_to :follower, Project2.Users.User
		belongs_to :following, Project2.Users.User

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :following_id])
    |> validate_required([:follower_id, :following_id])
    |> unique_constraint(:follower_id, name: :follows_follower_id_following_id_index)
  end
end
