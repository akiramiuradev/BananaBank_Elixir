defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.ViaCep.Client, as: ViaCepClient

  def call(%{"cep" => cep} = params) do
  with {:ok, %{"erro" => true}} <- ViaCepClient.call(cep) do
    {:error, :invalid_cep}
  else
    {:ok, _cep_data} ->
      params
      |> User.changeset()
      |> Repo.insert()

    error ->
      error
  end
end

end
