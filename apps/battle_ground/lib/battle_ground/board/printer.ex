defmodule BattleGround.Board.Printer do
  @max_x 11
  @min_x 0
  @max_y 11
  @min_y 0

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

  def print(board) do
    # from {11, 0} to {0, 11} (from right to left, from down to top)
    print_line(board, {@max_x, @min_y}, [print_tile("\n")])
  end

  defp print_line(board, {x, y}, memo) when x >= @min_x do
    print_line(board, {x - 1, y}, [print_tile(board, {x, y})|memo])
  end

  defp print_line(_board, {x, y}, memo) when x < @min_x and y == @max_y do
    [print_tile("\n")|memo]
  end

  defp print_line(board, {x, y}, memo) when x < @min_x do
    print_line(board, {@max_x, y + 1}, [print_tile("\n")|memo])
  end

  defp print_tile("\n"), do: "<br />"
  defp print_tile(board, coordinates) do
    case board[coordinates] do
      0 -> "<span style='background: black; width: 40px; height: 40px; display: inline-block;'>&nbsp;</span>"
      1 -> "<span style='background: white; width: 40px; height: 40px; display: inline-block;'>&nbsp;</span>"
      "X" -> "<span style='background-color: white; width: 40px; display: inline-block; height: 40px;'>X</span>"
      {color, name} -> "<span style='background-color: #{color}; width: 40px; display: inline-block; height: 40px;'>#{name}</span>"
      other -> "<span style='background: white; width: 40px; height: 40px; display: inline-block;'>#{other}</span>"
    end
  end
#  text
#  defp print_tile("\n"), do: "\n"
#  defp print_tile(board, coordinates) do
#    case board[coordinates] do
#      0 -> "0"
#      1 -> "_"
#      "X" -> "X"
#      {_color, name} -> name |> String.at(0)
#      other -> other
#    end
#  end
end
