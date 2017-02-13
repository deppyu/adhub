# -*- coding: utf-8 -*-
class CreateAccountTransactions < ActiveRecord::Migration
  def self.up
    create_table :account_transactions, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :account_id, :null=>false # 被操作账号
      t.integer :operator_id # 操作人, FK members(id)PARTY
      t.integer :operation, :null=>false, :default=>0  # 0: 充值， 1: 提现
      t.integer :op_way, :null=>false, :default=>0 # 操作方式: 0: 银行转账
      t.decimal :amount, :null=>0, :scale=>2, :precision=>12  # 发生金额
      t.string :note, :limit=>300
      t.timestamps
    end
  end

  def self.down
    drop_table :account_transactions
  end
end
