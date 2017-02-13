class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :pay_method_id, :null=>false
      t.integer :channel_id
      t.integer :party_id, :null=>false
      t.decimal :base_price, :scale=>4, :precision=>12, :null=>false, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
