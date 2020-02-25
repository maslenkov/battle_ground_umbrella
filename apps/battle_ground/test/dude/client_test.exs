defmodule BattleGround.Dude.ClientTest do
  use ExUnit.Case #, async: true

  # not sure, this tests looks like behavior, not unit :/
  setup_all do
    %{ dude_pid: BattleGround.Dude.Client.create("NAME")}
  end

  #  @tag :skip
  test "create Dude", %{ dude_pid: dude_pid } do
    assert {{_x, _y}, _is_alive, _name} = BattleGround.Dude.Client.state(dude_pid)
  end

  #  @tag :skip
  test "onboard Dude (adds it into subscribers)", %{ dude_pid: dude_pid } do
    lookup_results = Registry.lookup(BattleGround.Board.Registry, "board_subscribers")
    IO.inspect(lookup_results)
    IO.inspect(dude_pid)
    assert [{_registry_pid, ^dude_pid}] = lookup_results
  end

  #  @tag :skip
  test "movement", %{ dude_pid: dude_pid } do
    {{x, y}, is_alive, name} = BattleGround.Dude.Client.state(dude_pid)
    new_x = x - 1

    BattleGround.Dude.Client.go_left(dude_pid)

    assert {{^new_x, ^y}, ^is_alive, ^name} = BattleGround.Dude.Client.state(dude_pid)
  end

  test "attack", %{ dude_pid: dude_pid } do
    enemy_pid = BattleGround.Dude.Client.create("enemy")
    BattleGround.Dude.Client.set_coordinates({1, 1}, dude_pid)
    BattleGround.Dude.Client.set_coordinates({1, 2}, enemy_pid)
    BattleGround.Dude.Client.attack(dude_pid)

    assert {{_x, _y}, true, _name}  = BattleGround.Dude.Client.state(dude_pid)
    assert {{_x, _y}, false, _name} = BattleGround.Dude.Client.state(enemy_pid)

    # extract into self test: test "corpse"
    BattleGround.Dude.Client.attack(enemy_pid) # no result because of cast
    assert {{_x, _y}, true, _name}  = BattleGround.Dude.Client.state(dude_pid)
    assert :corpse = BattleGround.Dude.Client.go_up(enemy_pid)
    assert {{1, 2}, false, _name}  = BattleGround.Dude.Client.state(enemy_pid)
  end
end
