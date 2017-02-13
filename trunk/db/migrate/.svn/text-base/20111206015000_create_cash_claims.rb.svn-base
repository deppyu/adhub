class CreateCashClaims < ActiveRecord::Migration
  def self.up
    create_table :cash_claims, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :account_id, :null=>false
      t.integer :operator_id
      t.decimal :amount, :null=>false, :scale=>2, :precision=>12, :default=>0
      t.integer :result, :null=>false, :default=>0
      t.string :bank_name, :null=>false, :limit=>300
      t.string :account_no, :null=>false, :limit=>30
      t.string :account_name, :null=>false, :limit=>90
      t.string :fail_reason, :limit=>300
      t.string :bill_no, :limit=>50
      t.timestamps
    end

    SystemParameter.create! :name=>'claim_cash_low_limit', :value_type=>SystemParameter::INT_PARAM, :int_value=>100
  end

  def self.down
    drop_table :cash_claims
  end
end
