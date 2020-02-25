defmodule BattleGround.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # BattleGround.Worker
      BattleGround.Dude.Client,
      BattleGround.Dude.Server,
      {Registry, keys: :unique, name: BattleGround.Dude.Registry},

      {Registry, keys: :duplicate, name: BattleGround.Board.Registry},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BattleGround.Supervisor)
  end
end
