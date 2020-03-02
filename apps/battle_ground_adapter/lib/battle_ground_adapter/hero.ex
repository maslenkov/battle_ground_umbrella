defmodule BattleGroundAdapter.Hero do
  def touch(name) do
    unless BattleGround.Dude.RegistryClient.get_pid(name) do
      BattleGround.Dude.Client.create(name)
    end

    BattleGroundAdapter.DudeLifeCycle.update_last_seen(name)
  end
end
