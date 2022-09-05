# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string           default("USD"), not null
#  transaction_type :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#  reference_id     :integer
#
# Indexes
#
#  index_transactions_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :reference, class_name: 'Transaction', foreign_key: 'reference_id', optional: true

  validates :transaction_type, :amount_cents, presence: true

  monetize :amount_cents
  enum transaction_type: { inbound: 0, outbound: 1 }, _suffix: true
end
