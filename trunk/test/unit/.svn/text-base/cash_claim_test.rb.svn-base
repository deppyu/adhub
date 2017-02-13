require 'test_helper'

class CashClaimTest < ActiveSupport::TestCase
  def setup
    @publisher = parties (:publisher)
    @account = @publisher.account
    @account.save! 1000
    @cash_claim = @account.claim_cash 100, bank_accounts(:publisher_account)
  end

  test "failed" do
    @cash_claim.failed 'failed', members(:admin)
    assert ! @cash_claim.succeed?
    assert_equal 'failed', @cash_claim.fail_reason
    @publisher.reload
    assert_equal 1000, @publisher.account_balance
  end

  test "succeed" do
    @cash_claim.succeed '001', members(:admin)
    assert @cash_claim.succeed?
    assert_equal '001', @cash_claim.bill_no
    tran = @account.account_transactions.order('created_at desc').first
    assert_equal tran.operation, AccountTransaction::RETRIEVE_CASH
    assert_equal tran.amount, @cash_claim.amount
    puts tran.operator
    puts @cash_claim.operator
    assert_equal tran.operator, @cash_claim.operator
  end
  
end
