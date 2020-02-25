defmodule BattleGround.Dude.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call({:create, name}, _from, state) do
    { :ok, dude_pid } = BattleGround.Dude.start_link(name)
    # 1. Dude server contains only create step. Maybe it have to have another name?
    # 2. If we bring Dude's functions then I'm uncomfortable that this :create do three steps
    # 3. May be I can just break down spawn_hero into init_coordinates and set_coordinates
    # 4. MAYBE BEST: I can receive name and init_coordinates! ^^
    BattleGround.Board.spawn_hero(dude_pid) # set coordinates (NOT TESTED)
    Registry.register(BattleGround.Board.Registry, "board_subscribers", dude_pid) # use custom registry client: BattleGround.Board.Subscribers.add(dude_pid)
    {:reply, dude_pid, state}
  end
end
