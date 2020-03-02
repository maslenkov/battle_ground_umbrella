defmodule BattleGroundAdapter.DudeLifeCycle do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def enabled? do
    Process.whereis(__MODULE__)
  end

  def last_seen(name) do
    Agent.get(__MODULE__, &(&1[name]))
  end

  def update_last_seen(name) do
    Agent.update(__MODULE__, &(&1 |> Map.put(name, Time.utc_now())))
  end

  def afk?(name) do
    last_seen = BattleGroundAdapter.DudeLifeCycle.last_seen(name)
    Time.diff(Time.utc_now(), last_seen) > 4
  end
end
