class CreateAdRequests < ActiveRecord::Migration
  def self.up
    create_table :ad_requests, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :publisher_id, :null=>false
      t.integer :ad_container_id, :null=>false
      t.integer :agent_id
      t.integer :advertisement_id
      t.integer :publish_policy_id
      t.integer :campaign_id
      t.integer :ad_owner_id
      t.decimal :unit_price, :scale=>4, :precision=>10
      t.integer :pay_method_id
      t.boolean :fulfilled, :default=>false, :null=>false
      t.boolean :shown, :default=>false, :null=>false
      t.boolean :clicked, :default=>false, :null=>false
      t.boolean :paid, :default=>false, :null=>false
      t.float :publisher_share_rate
      t.float :agent_share_rate
      t.date :request_date
      t.string :ip_address, :limit=>15
      t.string :size_code, :limit=>20
      t.timestamps
    end

    add_index :ad_requests, :publisher_id
    add_index :ad_requests, :ad_owner_id
    add_index :ad_requests, :request_date
    add_index :ad_requests, [:ip_address, :ad_container_id, :size_code], :name=>'idx_ad_requests_ip_container_size'
  end

  def self.down
    drop_table :ad_requests
  end
end
