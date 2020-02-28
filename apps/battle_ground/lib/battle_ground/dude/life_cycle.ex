defmodule BattleGround.Dude.LifeCycle do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def when_last_seen(name) do
    Agent.get(__MODULE__, &(&1[name]))
  end

  def update_last_seen(name) do
    Agent.update(__MODULE__, &(&1 |> Map.put(name, Time.utc_now())))
  end
end
