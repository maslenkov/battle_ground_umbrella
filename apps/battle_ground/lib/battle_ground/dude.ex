# join with Dude.Server
defmodule BattleGround.Dude do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: {:via, Registry, {BattleGround.Dude.Registry, name}})
  end

  def init(name) do
    {:ok, {{0, 0}, true, name}}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:set_coordinates, new_coordinates}, _from, {_old_coordinates, is_alive, name}) do
    {:reply, :ok, {new_coordinates, is_alive, name}}
  end

  def handle_call({:go, _offsets}, _from, {_coordinates, false, _name} = state), do: {:reply, :corpse, state}

  def handle_call({:go, {offset_x, offset_y}}, _from, {{x, y}, is_alive, name}) do
    new_coordinates = case BattleGround.Board.check_coordinates({x + offset_x, y + offset_y}) do
      :wall -> {x, y}
      :walkable -> {x + offset_x, y + offset_y}
    end
    {:reply, :ok, {new_coordinates, is_alive, name}}
  end

  def handle_call({:attacked, {attacked_x, attacked_y}}, _from, {{x, y}, true, name} = state) do
    offset_x = attacked_x - x
    # IO.inspect(offset_x)
    offset_y = attacked_y - y
    # IO.inspect(offset_y)
    state = if(offset_x <= 1 && offset_x >= -1 && offset_y <=1 && offset_y >= -1) do
      # should be in separate step
      Process.send_after(self(), :respawn_self, 5 * 1000)
      {{x, y}, false, name}
    else
      state
    end

    # TODO: maybe return not a state?
    {:reply, state, state}
  end

  def handle_cast(:attack, {_coordinates, false, _name} = state), do: {:noreply, state}

  def handle_cast(:attack, {coordinates, true, _name} = state) do
    BattleGround.Board.attack(coordinates, self())
    {:noreply, state}
  end

  # TODO: SPECS!!!!
  def handle_info(:respawn_self, {coordinates, false, name}) do
    # set another coordinates
    {:noreply, {coordinates, true, name}}
  end
end
