defmodule Charla.Repo do
  use Ecto.Repo,
    otp_app: :charla,
    adapter: Ecto.Adapters.Postgres
end
