defmodule Project2.Follows.Follow do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [])
    |> validate_required([])
  end
end
