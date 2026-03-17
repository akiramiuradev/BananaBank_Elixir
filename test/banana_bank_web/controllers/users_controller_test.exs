defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.Users
  alias Users.User

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do

      params = %{
        name: "joão",
        cep: "12345678",
        email: "joao@joao.com",
        password: "12345678"
      }


      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
              "data" => %{
                "cep" => "12345678",
                "email" => "joao@joao.com",
                "id" => _id,
                "name" => "joão"
              },
              "message" => "User criado com sucesso"
            } = response

    end

    test "when there are invalid params, returns an error", %{conn: conn} do

      params = %{
        name: "joão",
        cep: "12",
        email: "joaojoao.com",
        password: "123456"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)


      expected_response = %{
              "errors" => %{
              "cep" => ["should be 8 character(s)"],
              "email" => ["has invalid format"],
              "password" => ["should be at least 8 character(s)"]
              }
            }

      assert response == expected_response

    end
  end

  describe "delete/2" do
    test "sucessfully deletes an user", %{conn: conn} do

    params = %{
        name: "joão",
        cep: "12345678",
        email: "joao@joao.com",
        password: "12345678"
      }

    {:ok, %User{id: id}} = Users.create(params)

    response =
      conn
      |> delete(~p"/api/users/#{id}")
      |> json_response(:ok)

    expected_response = %{
              "data" => %{
                "cep" => "12345678",
                "email" => "joao@joao.com",
                "id" => id,
                "name" => "joão"
              },
              "message" => "User deletado com sucesso"
            }

    assert response == expected_response

    end
  end
end
