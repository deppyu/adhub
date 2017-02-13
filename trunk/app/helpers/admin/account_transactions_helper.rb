module Admin::AccountTransactionsHelper
  
  def account_transaction_operation(account_transaction)
    operation = account_transaction.is_a?(AccountTransaction) ? account_transaction.operation : account_transaction.to_s.to_i
    t "account_transaction.operation.#{operation}"
  end
  
  def choices_account_transaction_operation
      AccountTransaction::ALL_OPERATION.collect{|t| [account_transaction_operation_fetch(t),t]}
  end

  def account_transaction_operation_fetch(operation)
      t "account_transaction.operation.#{operation}"
  end
end