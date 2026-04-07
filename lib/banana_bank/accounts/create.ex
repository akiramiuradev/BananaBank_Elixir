defmodule BananaBank.Accounts.Create do
  alias BananaBank.Accounts.Account
  alias BananaBank.Repo
  alias BananaBank.Users

  def call(%{"user_id" => user_id} = params) do
    with {:ok, _user} <- Users.get(user_id),
        {:ok, account} <- insert_account(params) do
    {:ok, account}

    else
      {:error, :not_found} -> {:error, :not_found}

      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
    end
  end

  defp insert_account(params) do
    params
      |> Account.changeset()
      |> Repo.insert()
  end
end
