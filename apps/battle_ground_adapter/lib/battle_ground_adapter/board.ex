defmodule BattleGroundAdapter.Board do
  def draw_html(name) do
    BattleGround.Board.Printer.prepare_board(BattleGround.Board.board, all_dudes(), hero(name))
    |> BattleGround.Board.HtmlPrinter.print
  end

  defp all_dudes do
    Registry.lookup(BattleGround.Board.Registry, "board_subscribers")
    |> Enum.map(fn({_registry_pid, dude_pid}) ->
      BattleGround.Dude.Client.state(dude_pid)
    end)
  end

  defp hero(name) do
    name
    |> BattleGround.Dude.RegistryClient.get_pid
    |> BattleGround.Dude.Client.state
  end
end
