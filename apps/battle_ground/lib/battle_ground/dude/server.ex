defmodule BattleGround.Dude.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call({:create, name}, _from, state) do
    {:ok, dude_pid} = DynamicSupervisor.start_child(BattleGround.Dude.Supervisor, { BattleGround.Dude, name })
    dude_pid |> BattleGround.Dude.Client.set_coordinates(BattleGround.Board.init_coordinates())
    Registry.register(BattleGround.Board.Registry, "board_subscribers", dude_pid)
    {:reply, dude_pid, state}
  end

  def handle_call({:delete, name}, _from, state) do
    dude_pid = name |> BattleGround.Dude.RegistryClient.get_pid
    Registry.unregister_match(BattleGround.Board.Registry, "board_subscribers", dude_pid)
    DynamicSupervisor.terminate_child(BattleGround.Dude.Supervisor, dude_pid)
    Registry.unregister(BattleGround.Dude.Registry, name)
    {:reply, :ok, state}
  end
end
