# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateTransferMoneyTransactions, type: :interactor do
  describe '.call' do
    let(:payload) do
      {
        sender: sender,
        receiver: receiver,
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
        expect(Transaction.all.count).to eq(2)
      end
    end
  end
end
