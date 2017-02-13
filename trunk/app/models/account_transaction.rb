# encoding: UTF-8
class AccountTransaction < ActiveRecord::Base
  # constants for op_way
  RECEIVE = 0 # 收入
  PAY = 1 # 支出
  
  # constants for operation 
  REFILL = 0 # 充值
  AD_FEE = 1 # 广告费支出
  AD_INCOME = 2 # 广告费收入
  RETRIEVE_CASH = 3 # 取现
  
  ALL_OPERATION = [REFILL,AD_FEE,AD_INCOME,RETRIEVE_CASH]

  validates_presence_of :account_id
  validates_presence_of :operator_id

  belongs_to :account
  belongs_to :operator,
             :class_name => "Member",
             :foreign_key => "operator_id"
end
