class FindAccount
  include Interactor

  def call
    find_account
  end

  private

  def find_account
    context.account = Account.find_by(id: context.account_id)
  end
end
