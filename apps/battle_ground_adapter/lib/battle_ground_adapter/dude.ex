defmodule BattleGroundAdapter.Dude do
  def action(name, "ArrowUp"),    do: name |> dude_pid |> BattleGround.Dude.Client.go_up
  def action(name, "ArrowRight"), do: name |> dude_pid |> BattleGround.Dude.Client.go_right
  def action(name, "ArrowDown"),  do: name |> dude_pid |> BattleGround.Dude.Client.go_down
  def action(name, "ArrowLeft"),  do: name |> dude_pid |> BattleGround.Dude.Client.go_left
  def action(name, "Space"),      do: name |> dude_pid |> BattleGround.Dude.Client.attack
  def action(_name, _key),        do: :noop

  defp dude_pid(name) do
    name |> BattleGround.Dude.RegistryClient.get_pid
  end
end
