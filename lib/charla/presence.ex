defmodule Charla.Presence do
  use Phoenix.Presence,
    otp_app: :charla,
    pubsub_server: Charla.PubSub
end
