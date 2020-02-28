defmodule BattleGroundWeb.GameController do
  use BattleGroundWeb, :controller

  def index(conn, params) do
    name = params["name"] || get_session(conn, :name) || random_name()

    unless BattleGround.Dude.RegistryClient.get_pid(name) do
      BattleGround.Dude.Client.create(name)
    end

    conn = put_session(conn, :name, name)
    BattleGround.Dude.LifeCycle.update_last_seen(name)

    board = BattleGround.Board.Printer.print(name)
    render(conn, "index.html", board: board)
  end

  def key(conn, params) do
    key = params["key"]
    name = get_session(conn, :name)
#    hide Registry lookup under dude client!!!
    [{dude_pid, nil}] = Registry.lookup(BattleGround.Dude.Registry, name)
    case key do
      "ArrowUp" -> BattleGround.Dude.Client.go_up(dude_pid)
      "ArrowRight" -> BattleGround.Dude.Client.go_right(dude_pid)
      "ArrowDown" -> BattleGround.Dude.Client.go_down(dude_pid)
      "ArrowLeft" -> BattleGround.Dude.Client.go_left(dude_pid)
      "Space" -> BattleGround.Dude.Client.attack(dude_pid)
      other -> IO.inspect(other)
    end
#    render(conn, "index.html", board: board)
    text conn, "OK"
#    redirect(conn, to: "/game")
  end

  def random_name do
    %{1 => "Woody", 2 => "Buzz", 3 => "Bonnie", 4 => "Jessie"}[:rand.uniform(4)]
  end
end
