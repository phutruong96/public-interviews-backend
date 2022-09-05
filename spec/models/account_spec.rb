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
require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { build(:account) }

  describe 'associations' do
    it { is_expected.to have_many(:transactions) }
  end
  it 'has a valid factory' do
    expect(account).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_values('alice@example.com', 'abc?/.-_+a@example.com').for(:email) }
    it { is_expected.not_to allow_values('alice@example', 'example.com', 'abc?/.-_a@日本語ドメイン.com').for(:email) }

    context 'when update with unique email' do
      subject(:update) do
        account = described_class.find(create(:account).id)
        account.update(email: Faker::Internet.safe_email)
      end

      it { is_expected.to be(true) }
    end

    context 'when update with duplicated email' do
      subject(:update) do
        account = described_class.find(create(:account).id)
        account.update(email: exist_account.email)
        account.errors.messages
      end

      let(:exist_account) { create(:account) }

      it { is_expected.to include(:email) }
    end
  end
end
