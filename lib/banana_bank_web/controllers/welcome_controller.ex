defmodule BananaBankWeb.WelcomeController do
  use BananaBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{message: "Bem vindo ao BananaBank"})
  end
end
