# BattleGround.Umbrella

Very simple MMO game

## Deployment

### Local developemtn

Run server with
```bash
mix phx.server
```

Run test with
```bash
mix test
```

### Release

#### Local build with mix release

```bash
MIX_ENV=test PORT=4000 SECRET_KEY_BASE=$(mix phx.gen.secret) mix release
PORT=4000 _build/test/rel/battle_ground/bin/battle_ground start
```

#### Deploy to heroku with Docker

```bash
heroku apps:create --stack=container APP_NAME
heroku config:set SECRET_KEY_BASE=$(mix phx.gen.secret)
git push heroku HEAD
open https://APP_NAME.herokuapp.com/
```

#### Local build with Docker

```bash
export SECRET_KEY_BASE=$(mix phx.gen.secret)
docker build --build-arg SECRET_KEY_BASE --build-arg PORT=4000 -t battle_ground ./
docker run -p 4000:4000 -e SECRET_KEY_BASE -e "PORT=4000" battle_ground
```

`ctrl+c` to exit or kill last created container with `docker kill $(docker ps -lq)`
