defmodule BattleGroundWeb.PageController do
  use BattleGroundWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
