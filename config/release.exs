import Config

config :battle_ground_web, BattleGroundWeb.Endpoint,
       http: [port: System.fetch_env!("PORT")],
       secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
