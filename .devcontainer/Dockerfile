# Update the VARIANT arg in docker-compose.yml to pick an Elixir version: 1.9, 1.10, 1.10.4
ARG VARIANT="1.13.4"
FROM elixir:${VARIANT}

# Optional Settings for Phoenix
ARG PHOENIX_VERSION="1.6.11"

# Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"

RUN apt-get update
RUN apt-get install --yes build-essential postgresql-client inotify-tools

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new ${PHOENIX_VERSION}

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

WORKDIR /app
EXPOSE 4000
