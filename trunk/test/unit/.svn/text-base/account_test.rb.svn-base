require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @publisher = parties :publisher
    @bank_account = bank_accounts(:publisher_account)
    @account = @publisher.account
  end

  test "save" do
    assert_equal 0, @account.balance
    @account.save! 1000
    assert_equal 1000, @account.balance
  end

  test "withdraw" do
    assert_equal 0, @account.balance
    @account.save! 1000
    @account.withdraw! 500
    assert_equal 500, @account.balance
  end

  test "claim cash, enough balance" do
    @account.save! 1000
    @account.claim_cash 100, @bank_account
    assert_equal 900, @account.balance
    assert_equal 100, @account.fund_in_float
    claims = @account.pending_cash_claims
    assert_equal 1, claims.size
    claim = claims[0]
    assert_equal 100, claim.amount
    assert_equal @account, claim.account
    assert_equal @bank_account.bank_name, claim.bank_name
    assert_equal @bank_account.bank_serial, claim.account_no
    assert_equal @bank_account.account_name, claim.account_name
  end

  test "claim cash, twice" do
    @account.save! 1000
    @account.claim_cash 100, @bank_account
    @account.claim_cash 200, @bank_account
    assert_equal 700, @account.balance
    assert_equal 300, @account.fund_in_float
    claims = @account.pending_cash_claims
    assert_equal 2, claims.size
  end

  test "claim cash, no enough balance" do
    @account.save! 1000
    assert_raise NoEnoughBalance do
      @account.claim_cash @account.balance + 0.01, @bank_account
    end
    @account.reload
    assert_equal 1000, @account.balance
  end

end
