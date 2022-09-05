class API::V1::TransactionsController < ApplicationController
  before_action :get_account

  def index
    render json: @account&.transactions&.page(params[:page])
  end

  private

  def get_account
    @account ||= FindAccount.call(account_id: params[:account_id]).account
  end
end
