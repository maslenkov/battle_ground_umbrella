defmodule BattleGround.Dude.RegistryClient do
  def get_pid(name) do
    extract_pid(Registry.lookup(BattleGround.Dude.Registry, name))
  end

  defp extract_pid([]), do: nil
  defp extract_pid([{pid, nil}]), do: pid
end
