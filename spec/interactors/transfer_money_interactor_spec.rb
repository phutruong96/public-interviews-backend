# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferMoney, type: :interactor do
  describe '.call' do
    let(:payload) do
      {
        sender: sender.email,
        receiver: receiver.phone_number,
        amount: 5
      }
    end
    subject(:context) do
      described_class.call(payload)
    end

    context 'with valid params' do
      let(:sender) { create(:account, status: :verified, amount: 10) }
      let(:receiver) { create(:account, status: :verified, amount: 0) }

      it 'transfer money successfully' do
        expect(context.success?).to be(true)
        expect(context.sender.amount).to eq(Money.from_amount(5, 'USD'))
        expect(context.receiver.amount).to eq(Money.from_amount(5, 'USD'))
      end
    end

    context 'with invalid params (status)' do
      let(:sender) { create(:account, status: :pending, amount: 10) }
      let(:receiver) { create(:account, status: :verified, amount: 0) }

      it 'transfer money failure' do
        expect(context.failure?).to be(true)
        expect(context.sender.amount).to eq(Money.from_amount(10, 'USD'))
      end
    end

    context 'with invalid params (amount)' do
      let(:sender) { create(:account, status: :verified, amount: 1) }
      let(:receiver) { create(:account, status: :verified, amount: 0) }

      it 'transfer money failure' do
        expect(context.failure?).to be(true)
        expect(context.sender.amount).to eq(Money.from_amount(1, 'USD'))
      end
    end
  end
end
