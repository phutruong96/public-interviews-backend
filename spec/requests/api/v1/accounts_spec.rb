require 'rails_helper'

RSpec.describe 'API::V1::Accounts', type: :request do
  describe 'POST /api/v1/accounts/transfer' do
    let(:payload) do
      {
        sender: sender.email,
        receiver: receiver.phone_number,
        amount: 5
      }
    end
    let(:make_request) { post '/api/v1/accounts/transfer', as: :json, params: payload }
    let(:json) { JSON.parse(response.body) }

    context 'with valid params' do
      let(:sender) { create(:account, status: :verified, amount: 10) }
      let(:receiver) { create(:account, status: :verified) }

      it 'transfer money successsuly' do
        make_request
        expect(json['status']).to eq(200)
      end
    end

    context 'with invalid params (account not verified yet)' do
      let(:sender) { create(:account, status: :pending) }
      let(:receiver) { create(:account) }

      it 'transfer money failure' do
        make_request
        expect(json['status']).to eq(403)
        expect(json['message']).to eq('Sender is invalid')
      end
    end

    context 'with invalid params (amount not enought)' do
      let(:sender) { create(:account, status: :verified, amount: 1) }
      let(:receiver) { create(:account, status: :verified) }

      it 'transfer money failure' do
        make_request
        expect(json['status']).to eq(403)
        expect(json['message']).to eq("Sender's amount isn't enought")
      end
    end
  end
end
