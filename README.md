# Zapp

## Dependencies

Caddy server - so we can access the app in local development via https://somedomain.localhost
`brew install caddy`

## Setup

- `cp .env.sample .env` and update with necessary info
- `cp Caddyfile.sample Caddyfile` and update if necessary
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Visit [https:zapp.locahost](https:zapp.locahost) in your browser.

