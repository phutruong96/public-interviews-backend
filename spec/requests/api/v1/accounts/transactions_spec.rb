require 'rails_helper'

RSpec.describe "API::V1::Accounts::Transactions", type: :request do
  describe "GET /index" do
    let(:account) { create(:account) }
    let(:make_request) { get "/api/v1/accounts/#{account.id}/transactions", as: :json }
    let(:json) { JSON.parse(response.body) }

    context 'with valid params' do
      let(:transactions) { create_list(:transaction, 5, account: account) }

      it 'get transactions successfully' do
        make_request
        expect(response.status).to eq(200)
      end
    end
  end
end
