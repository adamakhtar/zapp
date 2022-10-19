defmodule Zapp.Repo do
  use Ecto.Repo,
    otp_app: :zapp,
    adapter: Ecto.Adapters.Postgres
end
