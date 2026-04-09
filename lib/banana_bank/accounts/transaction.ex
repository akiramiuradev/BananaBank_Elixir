defmodule BananaBank.Accounts.Transaction do
  alias Ecto.Multi
  alias BananaBank.Accounts
  alias Accounts.Account
  alias BananaBank.Repo

  def call(%{"from_account_id" => from_account_id, "to_account_id" => to_account_id, "value" => value}) do
    with %Account{} = from_account <- Repo.get(Account, from_account_id),
         %Account{} = to_account <- Repo.get(Account, to_account_id),
         {:ok, value} <- Decimal.cast(value),
         {:ok, true} <- validate_positive(value) do
      Ecto.Multi.new()
      |> withdraw(from_account, value)
      |> deposit(to_account, value)
      |> Repo.transaction()
      |> handle_transaction()
    else
      nil -> {:error, :not_found}
      :error -> {:error, "Invalid value"}
      {:error, :invalid_value} -> {:error, "Value must be greater than zero"}
    end
  end

  def call(_), do: {:error, "Invalid params"}

  defp withdraw(multi, to_account, value) do
    new_balance = Decimal.sub(to_account.balance, value)
    changeset = Account.changeset(to_account, %{balance: new_balance})
    Multi.update(multi, :withdraw, changeset)
  end

  defp deposit(multi, from_account, value) do
    new_balance = Decimal.add(from_account.balance, value)
    changeset = Account.changeset(from_account, %{balance: new_balance})
    Multi.update(multi, :deposit, changeset)
  end

  defp validate_positive(value) do
    if Decimal.compare(value, 0) == :gt do
      {:ok, true}
    else
      {:error, :invalid_value}
    end
  end

  defp handle_transaction({:ok, _result} = result), do: result
  defp handle_transaction({:error, _op, reason, _}), do: {:error, reason}
end
