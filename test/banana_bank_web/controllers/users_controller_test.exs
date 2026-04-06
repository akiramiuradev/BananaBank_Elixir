defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users
  alias Users.User

  setup do
    params = %{
        "name" => "joão",
        "cep" => "16520970",
        "email" => "joao@joao.com",
        "password" => "12345678"
    }

    body = %{
        "bairro" => "Centro (Bacuriti)",
        "cep" => "16520-970",
        "complemento" => "222",
        "ddd" => "14",
        "estado" => "São Paulo",
        "gia" => "2379",
        "ibge" => "3508801",
        "localidade" => "Cafelândia",
        "logradouro" => "Avenida Santo Antônio",
        "regiao" => "Sudeste",
        "siafi" => "6277",
        "uf" => "SP",
        "unidade" => "AGC Bacuriti"
      }

    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, body: body, user_params: params} do


      expect(BananaBank.ViaCep.ClientMock, :call, fn "16520970" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
              "data" => %{
                "cep" => "16520970",
                "email" => "joao@joao.com",
                "id" => _id,
                "name" => "joão"
              },
              "message" => "User criado com sucesso"
            } = response

    end

    test "when there are invalid params, returns an error", %{conn: conn} do

      params = %{
        name: nil,
        cep: "12",
        email: "joaojoao.com",
        password: "123456"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)



      expected_response = %{
              "errors" => %{
              "cep" => ["should be 8 character(s)"],
              "email" => ["has invalid format"],
              "password" => ["should be at least 8 character(s)"],
              "name" => ["can't be blank"]
              }
            }

      assert response == expected_response

    end
  end

  describe "delete/2" do
    test "sucessfully deletes an user", %{conn: conn, body: body, user_params: params} do

      expect(BananaBank.ViaCep.ClientMock, :call, fn "16520970" ->
        {:ok, body}
      end)

    {:ok, %User{id: id}} = Users.create(params)

    response =
      conn
      |> delete(~p"/api/users/#{id}")
      |> json_response(:ok)

    expected_response = %{
              "data" => %{
                "cep" => "16520970",
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
