defmodule CharlaWeb.Plugs.Authenticated do
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    user = Plug.Conn.get_session(conn, :current_user)
    cond do
      is_nil(user) ->
        conn
        |> redirect(to: "/")
        |> halt()
      true ->
        conn
    end
  end
end
