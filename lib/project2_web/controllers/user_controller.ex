defmodule Project2Web.UserController do
  use Project2Web, :controller

  alias Project2.Users
  alias Project2.Users.User
	alias Project2.Follows
	alias Project2.Follows.Follow


  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
		IO.puts "OOOOOOOOOOOOOOOOOOOO"
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
				|> put_session(:user_id, user.id)
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
		followers = Users.get_followers(id)
		changeset = Follows.change_follow(%Follow{})
    render(conn, "show.html", user: user, followers: followers, changeset: changeset)
  end

	alias Project2.Repo

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

	alias Project2.Follows

	def test(conn, %{"id" => id}) do
		users = Users.list_users()
   	render(conn, "index.html", users: users)
 	end


	def follow(conn, follower_id, following_id) do
		Follows.create_follow(%{follower: follower_id, following: following_id})
		conn
    |> put_flash(:info, "User followed successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
	end
end
