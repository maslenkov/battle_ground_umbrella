defmodule BattleGround.Board.HtmlPrinter do
  @max_x 11
  @min_x 0
  @max_y 11
  @min_y 0

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
      0 -> "<span style='background-color: black;'>&nbsp;</span>"
      1 -> "<span>&nbsp;</span>"
      "X" -> "<span>X</span>"
      {color, name} -> "<span style='background-color: #{color};'>#{name}</span>"
      other -> "<span>#{other}</span>"
    end
  end
end
