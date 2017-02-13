# TODO: Remove ad group
class CreateAdGroups < ActiveRecord::Migration
  def self.up
    create_table :ad_groups, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :campaign_id, :null=>false
      t.string :name, :limit=>120, :null=>false
      t.string :call_to_action, :limit=>10, :null=>false
      t.date :start_from, :null=>false
      t.date :end_to
      t.integer :pay_method_id, :null=>false
      t.decimal :bid_price, :scale=>2, :precision=>10
      t.decimal :daily_budget, :scale=>2, :precision=>10
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_groups
  end
end
