defmodule BattleGround.Board.Printer do
  def prepare_board(board, all_dudes, hero) do
    all_dudes
    |> convert_dudes_to_markers
    |> put_dudes_markers_to_board(board)
    |> put_hero_to_board(hero)
  end

  defp convert_dudes_to_markers(all_dudes) do
    all_dudes |> Enum.map(fn ({coordinates, _, _} = dude) ->
      {coordinates, dude_marker(dude)}
    end)
  end

  defp put_dudes_markers_to_board(dudes_markers, board) do
    dudes_markers |> Enum.reduce(board, fn ({coordinates, marker}, board) ->
      Map.put(board, coordinates, marker)
    end)
  end

  defp put_hero_to_board(board, {hero_coordinates, _is_alive, _name} = hero) do
    board |> Map.put(hero_coordinates, dude_marker(hero, "green"))
  end

  defp dude_marker({_, true, name}), do: {"red", name}
  defp dude_marker({_, false, _name}), do: "X"
  defp dude_marker({_, false, _name}, _), do: "X"
  defp dude_marker({_, true, name}, color), do: {color, name}
end
