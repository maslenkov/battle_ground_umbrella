defmodule BattleGroundWeb.GameController do
  use BattleGroundWeb, :controller

  def index(conn, params) do
    name = params["name"] || get_session(conn, :name) || random_name()

    BattleGroundAdapter.Hero.touch(name)
    conn = conn |> put_session(:name, name)
    board = name |> BattleGroundAdapter.Board.draw_html

    render(conn, "index.html", board: board)
  end

  def key(conn, params) do
    BattleGroundAdapter.Dude.action(get_session(conn, :name), params["key"])
    text conn, "OK"
  end

  defp random_name do
    %{1 => "Woody", 2 => "Buzz", 3 => "Bonnie", 4 => "Jessie"}[:rand.uniform(4)]
  end
end
