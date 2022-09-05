class TransferMoney
  include Interactor

  def call
    handle_transfer_money
  end

  private

  def handle_transfer_money
    amount = Money.from_amount(context.amount.to_f, 'USD')
    context.sender = Account.find_by_email_or_phone_number context.sender
    context.fail!(error: 'Sender is invalid') unless context.sender&.verified_status?
    context.fail!(error: "Sender's amount isn't enought") unless context.sender&.amount >= amount

    context.receiver = Account.find_by_email_or_phone_number context.receiver
    context.fail!(error: 'Receiver is invalid') unless context.receiver&.verified_status?

    ActiveRecord::Base.transaction do
      context.sender.update(amount: context.sender.amount - amount)
      context.receiver.update(amount: context.receiver.amount + amount)
      CreateTransferMoneyTransactions.call(sender: context.sender, receiver: context.receiver, amount: amount)
    end
  end
end
