defmodule CharlaWeb.Router do
  use CharlaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CharlaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Ueberauth
    plug CharlaWeb.Plugs.Authenticated
  end

  scope "/auth", CharlaWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", CharlaWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  scope "/chat", CharlaWeb do
    pipe_through :browser
    pipe_through :authenticated

    live "/", MessageLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CharlaWeb do
  #   pipe_through :api
  # end

  # defp put_current_user(conn, _) do
  #   current_user = conn.assigns[:ueberauth_auth] && conn.assigns[:ueberauth_auth][:info]
  # end
end
