defmodule BattleGround.Dude.Client do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def create(name) do
    GenServer.call(BattleGround.Dude.Server, {:create, name})
  end

  def delete(name) do
    GenServer.call(BattleGround.Dude.Server, {:delete, name})
  end

  def state(dude_pid) do
    GenServer.call(dude_pid, :state)
  end

  def set_coordinates(dude_pid, coordinates) do
    GenServer.cast(dude_pid, {:set_coordinates, coordinates})
  end

  def go_left(dude_pid) do
    GenServer.call(dude_pid, {:go, {-1, 0}})
  end

  def go_right(dude_pid) do
    GenServer.call(dude_pid, {:go, {+1, 0}})
  end

  def go_down(dude_pid) do
    GenServer.call(dude_pid, {:go, {0, -1}})
  end

  def go_up(dude_pid) do
    GenServer.call(dude_pid, {:go, {0, +1}})
  end

  def attack(dude_pid) do
    GenServer.cast(dude_pid, :attack)
  end

  def attacked(dude_pid, coordinates) do
    GenServer.call(dude_pid, {:attacked, coordinates})
  end
end
