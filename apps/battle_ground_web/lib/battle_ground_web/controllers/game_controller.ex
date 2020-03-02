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
    key = params["key"]
    name = get_session(conn, :name)
# BattleGrounfAdapter.actuion()
    dude_pid = BattleGround.Dude.RegistryClient.get_pid(name)
    # TODO: change go_up into go(:up, name)
    case key do
      "ArrowUp" -> BattleGround.Dude.Client.go_up(dude_pid)
      "ArrowRight" -> BattleGround.Dude.Client.go_right(dude_pid)
      "ArrowDown" -> BattleGround.Dude.Client.go_down(dude_pid)
      "ArrowLeft" -> BattleGround.Dude.Client.go_left(dude_pid)
      "Space" -> BattleGround.Dude.Client.attack(dude_pid)
      _ -> :noop
    end
# / BattleGrounfAdapter.actuion()
    text conn, "OK"
  end

  def random_name do
    %{1 => "Woody", 2 => "Buzz", 3 => "Bonnie", 4 => "Jessie"}[:rand.uniform(4)]
  end
end
