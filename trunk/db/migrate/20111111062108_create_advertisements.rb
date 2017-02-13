# encoding: UTF-8
class CreateAdvertisements < ActiveRecord::Migration
  def self.up
    create_table :advertisements, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :party_id, :null=>false
      t.integer :status, :null=>false, :default=>0
      t.integer :impression_count, :default=>0
      t.integer :click_count, :default=>0
      t.decimal :used_budget, :scale=>4, :precision=>14,  :default=>0
      t.boolean :owner_maintained, :null=>false, :default=>true # 广告主自行维护。false 表示由代理商代为维护
      t.string :ad_format, :null=>false, :limit=>20
      t.string :name, :null=>false, :limit=>120
      t.string :content_url, :null=>false, :limit=>255
      t.timestamps
    end

  end

  def self.down
    drop_table :advertisements
  end
end
