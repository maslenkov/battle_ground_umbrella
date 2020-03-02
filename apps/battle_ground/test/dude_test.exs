defmodule BattleGround.DudeTest do
  use ExUnit.Case, async: true

  setup do
    dude_pid = start_supervised!({BattleGround.Dude, "DUDE NAME"})
    BattleGround.Dude.Client.set_coordinates(dude_pid, {1, 1})
    %{ dude_pid: dude_pid }
  end

  test "movement validation", %{ dude_pid: dude_pid } do
    {{1, 1}, is_alive, name} = BattleGround.Dude.Client.state(dude_pid)

    BattleGround.Dude.Client.go_left(dude_pid)

    assert {{1, 1}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)
  end

  test "right -> up -> left -> down", %{ dude_pid: dude_pid } do
    {{1, 1}, is_alive, name} = BattleGround.Dude.Client.state(dude_pid)

    BattleGround.Dude.Client.go_right(dude_pid)

    assert {{2, 1}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)

    BattleGround.Dude.Client.go_up(dude_pid)

    assert {{2, 2}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)

    BattleGround.Dude.Client.go_left(dude_pid)

    assert {{1, 2}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)

    BattleGround.Dude.Client.go_down(dude_pid)

    assert {{1, 1}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)
  end
end
