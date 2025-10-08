FROM elixir:1.18-otp-27-alpine AS builder

ENV MIX_ENV=prod\
  BIN=/usr/local/bin\
  PATH=/root/.mix/escripts:$PATH

RUN apk add --no-cache git openssl &&\
  mix local.hex --force &&\
  mix local.rebar --force

WORKDIR /opt/app

COPY . .

RUN mix deps.get &&\
  mix deps.compile &&\
  mix release

FROM alpine:3.22
LABEL maintainer="legend@shadowlegend.me"

ENV LANG=en_US.UTF-8\
  HOME=/opt/app\
  MIX_ENV=prod
WORKDIR $HOME

RUN apk --no-cache add libncursesw openssl libstdc++ &&\
  addgroup genx &&\
  adduser -D -G genx xuser &&\
  mkdir -p $HOME/logs

COPY --from=builder $HOME/_build/prod/rel/ory_kratos_admin/. $HOME/

RUN chown -R xuser:genx $HOME

USER xuser
