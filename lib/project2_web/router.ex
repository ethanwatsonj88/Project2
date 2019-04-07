defmodule Project2Web.Router do
  use Project2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
		plug Project2Web.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Project2Web do
    pipe_through :browser

    get "/", PageController, :index
		resources "/songs", SongController
		resources "/users", UserController
		resources "/follows", FollowController

		resources "/session", SessionController, only: [:create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", Project2Web do
  #   pipe_through :api
  # end

end
