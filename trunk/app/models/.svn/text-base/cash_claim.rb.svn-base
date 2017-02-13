# -*- coding: utf-8 -*-
class CashClaim < ActiveRecord::Base
  PENDING = 0
  SUCCEED = 1
  FAILED = 2

  ALL_RESULTS = [PENDING, SUCCEED, FAILED]

  belongs_to :account
  belongs_to :operator, :class_name=>'Member', :foreign_key=>'operator_id'
  validates_presence_of :bill_no, :if=>Proc.new { |c| SUCCEED == c.result }
  validates_length_of :bill_no, :maximum=>30
  validates_presence_of :fail_reason, :if=>Proc.new { |c| FAILED == c.result }
  validates_length_of :fail_reason, :maximum=>100

  scope :pending, where(:result=>PENDING)

  def bank_account_summary
    [bank_name, account_no, account_name].join(' ')
  end

  def succeed(bill_no, operator)
    self.transaction do
      self.update_attributes :result=>SUCCEED, :bill_no=>bill_no, :operator_id=>operator.id
      self.account.account_transactions.create! :op_way=>AccountTransaction::PAY, :operation=>AccountTransaction::RETRIEVE_CASH,
      :note=>'提现', :operator_id=>operator.id, :amount=>self.amount
    end
  end

  def failed(reason, operator)
    self.transaction do
      self.update_attributes :result=>FAILED, :fail_reason=>reason, :operator_id=>operator.id
      self.account.save! self.amount
    end
  end

  def succeed?
    SUCCEED == self.result
  end
end
