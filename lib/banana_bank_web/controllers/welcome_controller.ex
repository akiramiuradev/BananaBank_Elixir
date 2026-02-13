defmodule BananaBankWeb.WelcomeController do
  use BananaBankWeb, :controller

  def index(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)

    conn
  end
end
