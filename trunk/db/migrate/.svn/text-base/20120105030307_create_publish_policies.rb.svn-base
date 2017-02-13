class CreatePublishPolicies < ActiveRecord::Migration
  def self.up
    create_table :publish_policies, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :campaign_id, :null=>false
      t.integer :advertisement_id, :null=>false
      t.integer :channel_id, :null=>false
      t.integer :status, :null=>false, :default=>0 
      t.date :start_from, :null=>false
      t.date :end_to
      t.integer :pay_method_id, :null=>false
      t.decimal :bid_price, :scale=>4, :precision=>12
      t.decimal :daily_budget, :scale=>2, :precision=>10
      t.decimal :used_budget, :scale=>4, :precision=>14, :default=>0
      t.string :name, :limit=>120, :null=>false
      t.string :call_to_action, :limit=>30, :null=>false, :default=>'url'
      t.timestamps
      t.text :call_to_action_params
    end
  end

  def self.down
    drop_table :publish_policies
  end
end
