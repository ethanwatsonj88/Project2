defmodule Project2Web.FollowController do
  use Project2Web, :controller

  alias Project2.Follows
  alias Project2.Follows.Follow
  alias Project2.Repo
  alias Project2.Users

  def index(conn, _params) do
    follows = Follows.list_follows()
    render(conn, "index.html", follows: follows)
  end

  def new(conn, _params) do
    changeset = Follows.change_follow(%Follow{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"follow" => follow_params}) do
    case Follows.create_follow(follow_params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Follow created successfully.")
        |> redirect(to: Routes.follow_path(conn, :show, follow))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect follow_params
        user = Users.get_user!(String.to_integer(follow_params["following_id"]))
        |> Repo.preload(:follows)

    		changeset = Follows.change_follow(%Follow{})
        conn
        |> put_flash(:error, "Follow failed. Are you already followed?")
        |> render(Project2Web.UserView, "show.html", user: user,
               followers: Users.get_followers(user.id),
               followings: Users.get_followings(user.id),
               changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    follow = Follows.get_follow!(id)
    |> Repo.preload(:follower)
    |> Repo.preload(:following)
    render(conn, "show.html", follow: follow)
  end

  def edit(conn, %{"id" => id}) do
    follow = Follows.get_follow!(id)
    changeset = Follows.change_follow(follow)
    render(conn, "edit.html", follow: follow, changeset: changeset)
  end

  def update(conn, %{"id" => id, "follow" => follow_params}) do
    follow = Follows.get_follow!(id)

    case Follows.update_follow(follow, follow_params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Follow updated successfully.")
        |> redirect(to: Routes.follow_path(conn, :show, follow))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", follow: follow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    follow = Follows.get_follow!(id)
    {:ok, _follow} = Follows.delete_follow(follow)

    conn
    |> put_flash(:info, "Follow deleted successfully.")
    |> redirect(to: Routes.follow_path(conn, :index))
  end
end
