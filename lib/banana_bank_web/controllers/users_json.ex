defmodule BananaBankWeb.UsersJSON do

  alias BananaBank.Users.User
  def create(%{user: user}) do
    %{
      message: "User criado com sucesso",
      data: data(user)
    }
  end

  def delete(%{user: user}) do
    %{
      message: "User deletado com sucesso",
      data: data(user)
    }
  end

   def get(%{user: user}) do
    %{
      data: data(user)
    }
  end

  def update(%{user: user}) do
    %{
      message: "User atualizado com sucesso",
      data: data(user)
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      cep: user.cep,
      email: user.email,
      name: user.name
    }
  end
end
