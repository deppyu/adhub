class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :party_id, :null=>false
      t.decimal :balance, :scale=>4, :precision=>14, :null=>false, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
