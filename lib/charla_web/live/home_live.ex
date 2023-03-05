defmodule CharlaWeb.HomeLive do
  use CharlaWeb, :live_view
  alias Charla.PubSub

  def mount(_params, session, socket) do
    {:ok, assign(socket, current_user: Map.get(session, "current_user"))}
  end

  def render(assigns) do
    CharlaWeb.HomeView.render("home.html", assigns)
  end
end
