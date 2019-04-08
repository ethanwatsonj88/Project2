defmodule Project2Web.AuthController do
  use Project2Web, :controller
  alias Project2.Users.User
  alias Project2.Users
  alias Project2.Repo

  def index(conn, _params) do
    redirect conn, external: Google.authorize_url!(scope: "https://www.googleapis.com/auth/drive")
  end

  def callback(conn, %{"code" => code}) do
    token = Google.get_token!(code: code)
    IO.inspect token
    data = OAuth2.Client.get!(token, "https://www.googleapis.com/drive/v2/about").body
    IO.inspect data
    user_name = data["user"]["displayName"]
    email_addr = data["user"]["emailAddress"]

    user = Users.get_user_by_email(email_addr)
		IO.puts "\n\n\n\nDISPLAY USER\n\n\n\n"
    inspect user
    user = if user do
      user
    else
      changeset = User.changeset(%User{},
        %{user_id: token.token.other_params["user_id"],
          access_token: token.token.access_token,
          refresh_token: token.token.refresh_token,
          username: user_name,
          email: email_addr
        })
    Repo.insert!(changeset)
    end

    conn
      |> put_session(:user_id, user.id)
      |> put_session(:client, token)
      |> put_flash(:info, "Hello #{user.username}!")
      |> redirect(to: "/")
  end
end
