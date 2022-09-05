class AddAmountToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_monetize :accounts, :amount
  end
end
