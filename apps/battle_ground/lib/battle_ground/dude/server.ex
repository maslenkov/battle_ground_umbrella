defmodule BattleGround.Dude.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call({:create, name}, _from, state) do
    # TODO: we have to provide "respawn coordinates and _alive_status"
    {:ok, dude_pid} = DynamicSupervisor.start_child(BattleGround.Dude.Supervisor, { BattleGround.Dude, name })
    # 1. Dude server contains only create step. Maybe it have to have another name?
    # 2. If we bring Dude's functions then I'm uncomfortable that this :create do three steps
    # 3. May be I can just break down spawn_hero into init_coordinates and set_coordinates
    # 4. MAYBE BEST: I can receive name and init_coordinates! ^^
    BattleGround.Board.spawn_hero(dude_pid) # set coordinates (NOT TESTED)
    Registry.register(BattleGround.Board.Registry, "board_subscribers", dude_pid) # use custom registry client: BattleGround.Board.Subscribers.add(dude_pid)
    {:reply, dude_pid, state}
  end

  def handle_call({:delete, name}, _from, state) do
    # find dude
    [{dude_pid, _}] = Registry.lookup(BattleGround.Dude.Registry, name)
    # unregister from attack
    Registry.unregister_match(BattleGround.Board.Registry, "board_subscribers", dude_pid) # use custom registry client: BattleGround.Board.Subscribers.add(dude_pid)
    # Delete Dude
    DynamicSupervisor.terminate_child(BattleGround.Dude.Supervisor, dude_pid)
    # remove name from registry name
    Registry.unregister(BattleGround.Dude.Registry, name)
    {:reply, :ok, state}
  end
end
