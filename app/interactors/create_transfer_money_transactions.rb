class CreateTransferMoneyTransactions
  include Interactor

  def call
    create_transactions
  end

  private

  def create_transactions
    ActiveRecord::Base.transaction do
      outbound_transaction = context.sender.transactions.create(amount: context.amount * (-1), transaction_type: :outbound)
      inbound_transaction = context.receiver.transactions.create(amount: context.amount, transaction_type: :inbound, reference: outbound_transaction)
      outbound_transaction.update(reference: inbound_transaction)
    end
  end
end
