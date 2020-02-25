defmodule BattleGround.Board.Printer do
  @max_x 11
  @min_x 0
  @max_y 11
  @min_y 0

  def print(separator \\ "\n") do
    # from {11, 0} to {0, 11} (from right to left, from down to top)
    print_line(@max_x, @min_y, [separator], separator)
  end

  defp print_line(x, y, memo, separator) when x >= @min_x do
    print_line(x - 1, y, [print_tile(x, y)|memo], separator)
  end

  defp print_line(x, y, memo, separator) when x <= @min_x and y == @max_y do
    [separator|memo]
  end

  defp print_line(x, y, memo, separator) when x <= @min_x do
    print_line(@max_x, y + 1, [separator|memo], separator)
  end

  defp print_tile(x, y) do
    # where is tests!?!?!
    dude = Registry.lookup(BattleGround.Board.Registry, "board_subscribers")
           |> Enum.map(fn({_registry_pid, dude_pid}) ->
      BattleGround.Dude.Client.state(dude_pid)
    end)
           |> Enum.find(fn({coordinates, _is_alive, _name}) ->
      coordinates == {x, y}
    end)
    # why without test first?
    if(dude) do
      {_, is_alive, name} = dude
      if is_alive do
        name |> String.at(0)
      else
        "X"
      end
    else
      #    ---
      case BattleGround.Board.get_by_coordinates({x, y}) do
        0 -> "0"
        1 -> "_"
        other -> other
      end
    end
  end
end
