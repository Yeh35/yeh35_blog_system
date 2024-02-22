# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian
# instead of Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20230612-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.15.6-erlang-26.0.2-debian-bullseye-20230612-slim
#
ARG ELIXIR_VERSION=1.15.6
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20230612-slim
ARG UBUNTU_VERSION=jammy-20230126

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-ubuntu-${UBUNTU_VERSION}"
ARG RUNNER_IMAGE="ubuntu:${UBUNTU_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y
RUN apt-get install -y nodejs npm
RUN apt-get install -y build-essential git
RUN apt-get clean && rm -f /var/lib/apt/lists/*_*


# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# mix deps.get 가 안되는 이슈가 있어서 추가
# https://elixirforum.com/t/mix-deps-get-memory-explosion-when-doing-cross-platform-docker-build/57157/3
ENV ERL_FLAGS="+JPperf true"

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/yeh35_blog/mix.exs apps/yeh35_blog/mix.exs
RUN mix deps.get --only $MIX_ENV

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
RUN mkdir config
COPY config/config.exs config/
COPY apps/yeh35_blog/config/config.exs apps/yeh35_blog/config/${MIX_ENV}.exs apps/yeh35_blog/config/
RUN mix deps.compile

COPY apps/yeh35_blog/priv apps/yeh35_blog/priv

COPY apps/yeh35_blog/lib apps/yeh35_blog/lib

COPY apps/yeh35_blog/assets apps/yeh35_blog/assets

# compile assets
RUN npm install --prefix ./apps/yeh35_blog/assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY apps/yeh35_blog/config/runtime.exs config/

#COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
  apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/ko_KR.UTF- 8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/yeh35 ./

USER nobody

# If using an environment that doesn't automatically reap zombie processes, it is
# advised to add an init process such as tini via `apt-get install`
# above and adding an entrypoint. See https://github.com/krallin/tini for details
# ENTRYPOINT ["/tini", "--"]

ENTRYPOINT ["/app/bin/yeh35", "start"]
