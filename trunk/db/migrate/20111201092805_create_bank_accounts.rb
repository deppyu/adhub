class CreateBankAccounts < ActiveRecord::Migration
  def self.up
    create_table :bank_accounts,:options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :party_id,:null=>false
      t.string :bank_name,:null=>false,:limit=>300
      t.string :account_name,:null=>false,:limit=>90
      t.string :bank_serial,:null=>false,:limit=>30
      t.timestamps
    end
  end

  def self.down
    drop_table :bank_accounts
  end
end

