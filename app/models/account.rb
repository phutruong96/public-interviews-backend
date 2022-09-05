# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id              :bigint           not null, primary key
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("USD"), not null
#  email           :string
#  first_name      :string
#  last_name       :string
#  phone_number    :string
#  status          :integer          default("pending"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_accounts_on_email         (email)
#  index_accounts_on_phone_number  (phone_number)
#  index_accounts_on_status        (status)
#
class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  EMAIL_REGEXP = %r{\A[0-9a-z_./?+-]+@([0-9a-z-]+\.)+[0-9a-z-]+\z}

  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :email, format: { with: EMAIL_REGEXP }
  validates :email, uniqueness: { case_sensitive: false }, on: :update
  validates_numericality_of :amount_cents, greater_than_or_equal_to: 0

  monetize :amount_cents
  enum status: {
    unverified: -1,
    pending: 0,
    verified: 1
  }, _suffix: true

  def self.find_by_email_or_phone_number(param)
    find_by('phone_number = ? OR email = ?', param, param)
  end
end
