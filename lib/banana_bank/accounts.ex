defmodule BananaBank.Accounts do
  alias BananaBank.Accounts.Create
  alias BananaBank.Accounts.Transaction

  defdelegate create(params), to: Create, as: :call
  defdelegate transactions(params), to: Transaction, as: :call
end
