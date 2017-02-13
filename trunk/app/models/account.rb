class Account < ActiveRecord::Base
  belongs_to :party
  has_many :account_transactions
  has_many :cash_claims

  def save!(amount)
    self.connection.execute "update accounts set balance = balance + #{amount} where id = #{self.id}"    
    self.reload
  end

  def withdraw!(amount)
    self.connection.execute "update accounts set balance = balance - #{amount} where id = #{self.id}"    
    self.reload
  end

  def no_balance?
    self.balance <= 0
  end

  def claim_cash(amount, bank_account)
    self.transaction do
      self.withdraw! amount
      raise NoEnoughBalance.new if self.balance < 0
      self.cash_claims.create :amount=>amount, :bank_name=>bank_account.bank_name, :account_no=>bank_account.bank_serial,
      :account_name=>bank_account.account_name
    end
  end

  def fund_in_float
    self.pending_cash_claims.sum(:amount)
  end
  
  def pending_cash_claims
    self.cash_claims.pending
  end
end
