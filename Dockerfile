FROM elixir:1.10-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE="build time secret key"
ENV PORT=4000

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/battle_ground/mix.exs ./apps/battle_ground/
COPY apps/battle_ground_web/mix.exs ./apps/battle_ground_web/
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build assets
#COPY assets assets
COPY apps/battle_ground_web/priv apps/battle_ground_web/priv
#RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build project
COPY apps/battle_ground/lib apps/battle_ground/lib
COPY apps/battle_ground_web/lib apps/battle_ground_web/lib
RUN mix compile

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix release
RUN ls /app/_build/prod/rel/

# prepare release image
FROM alpine:3.11 AS app
RUN apk add --update bash openssl

RUN mkdir /app
WORKDIR /app

EXPOSE 4000

COPY --from=build /app/_build/prod/rel/battle_ground ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD ["./bin/battle_ground", "start"]
