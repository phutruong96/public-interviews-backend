class API::V1::AccountsController < ApplicationController
  def transfer
    result = TransferMoney.call(transfer_params)

    if result.success?
      render json: { status: 200 }
    else
      render json: { status: 400, message: result.error }
    end
  end

  private

  def transfer_params
    params.permit(:sender, :receiver, :amount)
  end
end
