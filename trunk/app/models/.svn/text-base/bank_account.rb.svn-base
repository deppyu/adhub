class BankAccount < ActiveRecord::Base
  
  validates_presence_of :bank_name
  validates_presence_of :account_name
  validates_presence_of :bank_serial
  validates_uniqueness_of :bank_serial, :scope=>[:party_id, :bank_name]

  belongs_to :party

end
