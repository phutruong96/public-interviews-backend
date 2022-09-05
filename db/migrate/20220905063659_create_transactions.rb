class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.monetize :amount, default: 0
      t.integer :transaction_type, null: false
      t.belongs_to :account, null: false, foreign_key: true
      t.integer :reference_id, foreign_key: true

      t.timestamps
    end
  end
end
