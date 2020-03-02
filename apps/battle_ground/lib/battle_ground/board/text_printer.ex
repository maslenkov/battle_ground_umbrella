defmodule BattleGround.Board.TextPrinter do
  @max_x 11
  @min_x 0
  @max_y 11
  @min_y 0

  def print(board) do
    # from {11, 0} to {0, 11} (from right to left, from down to top)
    print_line(board, {@max_x, @min_y}, [print_tile("\n")]) |> List.to_string
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

  defp print_tile("\n"), do: "\n"
  defp print_tile(board, coordinates) do
    case board[coordinates] do
      0 -> "0"
      1 -> "_"
      "X" -> "X"
      {_color, name} -> name |> String.at(0)
      other -> other
    end
  end
end
