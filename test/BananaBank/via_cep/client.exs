defmodule BananaBank.ViaCep.ClientTest do
    use ExUnit.Case, async: true

    alias BananaBank.ViaCep.Client

    setup do
        bypass = Bypass.open()
        {:ok, bypass: bypass}
    end

    describe "call/1" do
        test "successfully returns cep info" , %{bypass: bypass} do
            cep = "08696145"

            body = ~s({
                "bairro": "Jardim Varan",
                "cep": "08696-145",
                "complemento":  "",
                "ddd": "11",
                "estado": "São Paulo",
                "gia": "6725",
                "ibge": "3552502",
                "localidade": "Suzano",
                "logradouro": "Rua Kata Liciburg",
                "regiao": "Sudeste",
                "siafi": "7151",
                "uf": "SP",
                "unidade": ""
                })

            expected_response =
                 {:ok,
                    %{"bairro" => "Jardim Varan",
                    "cep" => "08696-145",
                    "complemento" => "",
                    "ddd" => "11",
                    "estado" => "São Paulo",
                    "gia" => "6725",
                    "ibge" => "3552502",
                    "localidade" => "Suzano",
                    "logradouro" => "Rua Kata Liciburg",
                    "regiao" => "Sudeste",
                    "siafi" => "7151",
                    "uf" => "SP",
                    "unidade" => ""
                 }}

            Bypass.expect(bypass, "GET", "/08696145/json", fn conn ->
                conn
                |> Plug.Conn.put_resp_content_type("application/json")
                |> Plug.Conn.resp(200, body)
            end)

            response =
                bypass.port
                |> endpoint_url()
                |> Client.call(cep)

            assert response == expected_response
        end
    end

    def endpoint_url(port), do: "http://localhost:#{port}"
end
