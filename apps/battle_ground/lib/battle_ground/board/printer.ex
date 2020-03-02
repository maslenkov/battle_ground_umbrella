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

  defp dude_marker({_, true, name}), do: "<span style='background-color: red; display: block; height: 40px;'>#{name}</span>"
  defp dude_marker({_, false, _name}), do: "<span>X</span>"
  defp dude_marker({_, false, _name}, _), do: "<span>X</span>"
  defp dude_marker({_, true, name}, color), do: "<span style='background-color: #{color}; display: block; height: 40px;'>#{name}</span>"

  def print(board) do
    # from {11, 0} to {0, 11} (from right to left, from down to top)
    print_line(board, {@max_x, @min_y}, ["<br />"])
  end

  defp print_line(board, {x, y}, memo) when x >= @min_x do
    print_line(board, {x - 1, y}, [print_tile(board, {x, y})|memo])
  end

  defp print_line(board, {x, y}, memo) when x < @min_x and y == @max_y do
    ["<br />"|memo]
  end

  defp print_line(board, {x, y}, memo) when x < @min_x do
    print_line(board, {@max_x, y + 1}, ["<br />"|memo])
  end

  defp print_tile(board, coordinates) do
    case board[coordinates] do
      0 -> "<span style='background: black; width: 40px; height: 40px; display: inline-block;'>&nbsp;</span>"
      1 -> "<span style='background: white; width: 40px; height: 40px; display: inline-block;'>&nbsp;</span>"
      other -> "<span style='background: white; width: 40px; height: 40px; display: inline-block;'>#{other}</span>"
    end
  end
end
