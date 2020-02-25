defmodule BattleGround.Board do
  #  use GenServer

  @field %{
    {0, 11} => 0, {1, 11} => 0, {2, 11} => 0, {3, 11} => 0, {4, 11} => 0, {5, 11} => 0, {6, 11} => 0, {7, 11} => 0, {8, 11} => 0, {9, 11} => 0, {10, 11} => 0, {11, 11} => 0,
    {0, 10} => 0, {1, 10} => 1, {2, 10} => 1, {3, 10} => 1, {4, 10} => 1, {5, 10} => 1, {6, 10} => 1, {7, 10} => 1, {8, 10} => 0, {9, 10} => 1, {10, 10} => 1, {11, 10} => 0,
    {0, 9} => 0, {1, 9} => 1, {2, 9} => 1, {3, 9} => 1, {4, 9} => 1, {5, 9} => 1, {6, 9} => 1, {7, 9} => 0, {8, 9} => 0, {9, 9} => 0, {10, 9} => 1, {11, 9} => 0,
    {0, 8} => 0, {1, 8} => 1, {2, 8} => 1, {3, 8} => 1, {4, 8} => 1, {5, 8} => 1, {6, 8} => 1, {7, 8} => 1, {8, 8} => 0, {9, 8} => 1, {10, 8} => 1, {11, 8} => 0,
    {0, 7} => 0, {1, 7} => 1, {2, 7} => 1, {3, 7} => 1, {4, 7} => 0, {5, 7} => 1, {6, 7} => 1, {7, 7} => 1, {8, 7} => 1, {9, 7} => 1, {10, 7} => 1, {11, 7} => 0,
    {0, 6} => 0, {1, 6} => 1, {2, 6} => 1, {3, 6} => 0, {4, 6} => 0, {5, 6} => 0, {6, 6} => 1, {7, 6} => 1, {8, 6} => 1, {9, 6} => 1, {10, 6} => 1, {11, 6} => 0,
    {0, 5} => 0, {1, 5} => 1, {2, 5} => 1, {3, 5} => 1, {4, 5} => 0, {5, 5} => 1, {6, 5} => 1, {7, 5} => 1, {8, 5} => 1, {9, 5} => 1, {10, 5} => 1, {11, 5} => 0,
    {0, 4} => 0, {1, 4} => 1, {2, 4} => 1, {3, 4} => 1, {4, 4} => 1, {5, 4} => 1, {6, 4} => 1, {7, 4} => 1, {8, 4} => 1, {9, 4} => 1, {10, 4} => 1, {11, 4} => 0,
    {0, 3} => 0, {1, 3} => 1, {2, 3} => 1, {3, 3} => 1, {4, 3} => 1, {5, 3} => 1, {6, 3} => 1, {7, 3} => 0, {8, 3} => 0, {9, 3} => 0, {10, 3} => 0, {11, 3} => 0,
    {0, 2} => 0, {1, 2} => 1, {2, 2} => 1, {3, 2} => 1, {4, 2} => 1, {5, 2} => 1, {6, 2} => 1, {7, 2} => 1, {8, 2} => 1, {9, 2} => 1, {10, 2} => 1, {11, 2} => 0,
    {0, 1} => 0, {1, 1} => 1, {2, 1} => 1, {3, 1} => 1, {4, 1} => 1, {5, 1} => 1, {6, 1} => 1, {7, 1} => 1, {8, 1} => 1, {9, 1} => 1, {10, 1} => 1, {11, 1} => 0,
    {0, 0} => 0, {1, 0} => 0, {2, 0} => 0, {3, 0} => 0, {4, 0} => 0, {5, 0} => 0, {6, 0} => 0, {7, 0} => 0, {8, 0} => 0, {9, 0} => 0, {10, 0} => 0, {11, 0} => 0
  }

  # WARNING: what is the aim of this method?
  def board do
    @field
  end

  # WARNING: spawn can introduce miss understanding :/
  def spawn_hero(dude_pid) do
    BattleGround.Dude.Client.set_coordinates(init_coordinates(), dude_pid)
  end

  def get_by_coordinates(coordinates) do
    @field[coordinates]
  end

  def check_coordinates(coordinates) do
    # TODO: try to make guard instead of case
    case @field[coordinates] do
      0 -> :wall
      _ -> :walkable
    end
  end

  def attack(coordinates, attack_from_pid) do
    # IO.inspect(123)
    Registry.dispatch(BattleGround.Board.Registry, "board_subscribers", fn(entries) ->
      for {_registry_pid, subscriber_pid} <- entries do
        unless subscriber_pid == attack_from_pid do
          BattleGround.Dude.Client.attacked(coordinates, subscriber_pid)
        end
      end
    end)
  end

  #  maybe tests? (NO TEST FOR PRIVATE FUNCTIONS!)
  defp init_coordinates do
    coordinates = {:rand.uniform(11), :rand.uniform(11)}
    case check_coordinates(coordinates) do
      :wall -> init_coordinates()
      :walkable -> coordinates
    end
  end
end