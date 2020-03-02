defmodule BattleGround.Dude.ClientTest do
  use ExUnit.Case

  setup_all do
    %{ dude_pid: BattleGround.Dude.Client.create("NAME")}
  end

  test "create Dude", %{ dude_pid: dude_pid } do
    assert {{_x, _y}, _is_alive, _name} = BattleGround.Dude.Client.state(dude_pid)
  end

  test "onboard Dude (adds it into subscribers)", %{ dude_pid: dude_pid } do
    lookup_results = Registry.lookup(BattleGround.Board.Registry, "board_subscribers")
    assert [{_registry_pid, ^dude_pid}] = lookup_results
  end

  test "movement", %{ dude_pid: dude_pid } do
    {_coordinates, is_alive, name} = BattleGround.Dude.Client.state(dude_pid)
    BattleGround.Dude.Client.set_coordinates(dude_pid, {2, 1})

    BattleGround.Dude.Client.go_left(dude_pid)

    assert {{1, 1}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)
  end

  test "attack", %{ dude_pid: dude_pid } do
    enemy_pid = BattleGround.Dude.Client.create("enemy")
    BattleGround.Dude.Client.set_coordinates(dude_pid, {1, 1})
    BattleGround.Dude.Client.set_coordinates(enemy_pid, {1, 2})
    BattleGround.Dude.Client.attack(dude_pid)

    assert {{_x, _y}, true, _name}  = BattleGround.Dude.Client.state(dude_pid)
    assert {{_x, _y}, false, _name} = BattleGround.Dude.Client.state(enemy_pid)

    BattleGround.Dude.Client.attack(enemy_pid)
    assert {{_x, _y}, true, _name}  = BattleGround.Dude.Client.state(dude_pid)
    assert :corpse = BattleGround.Dude.Client.go_up(enemy_pid)
    assert {{1, 2}, false, _name}  = BattleGround.Dude.Client.state(enemy_pid)

    BattleGround.Dude.Client.delete("enemy")
  end
end
