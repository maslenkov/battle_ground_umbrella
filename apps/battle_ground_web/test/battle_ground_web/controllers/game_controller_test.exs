defmodule BattleGroundWeb.GameControllerTest do
  use BattleGroundWeb.ConnCase

  test "GET /game", %{conn: conn} do
    conn = get(conn, "/game")
    assert html_response(conn, 200) =~ "Start game!"
  end
end
