defmodule BattleGroundWeb.Router do
  use BattleGroundWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
#    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BattleGroundWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/game", GameController, :index
    post "/game/key", GameController, :key
  end

  # Other scopes may use custom stacks.
  # scope "/api", BattleGroundWeb do
  #   pipe_through :api
  # end
end
