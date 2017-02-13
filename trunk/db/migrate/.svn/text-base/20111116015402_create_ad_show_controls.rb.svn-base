class CreateAdShowControls < ActiveRecord::Migration
  def self.up
    create_table :ad_show_controls do |t|
      t.integer :party_id, :null=>false
      t.integer :advertisement_id, :null=>false
      t.integer :publish_policy_id, :null=>false
      t.integer :campaign_id, :null=>false
      t.integer :channel_id, :null=>false
      t.float :weight
      t.decimal :unit_price, :null=>false, :scale=>4, :precision=>10
      t.date :begin, :null=>false
      t.date :end
      t.string :ad_format, :null=>false, :limit=>30
      t.string :size_codes, :limit=>300
      t.string :content_categories, :limit=>1024
      t.string :ad_containers, :limit=>4096
      t.timestamps
    end

    add_index :ad_show_controls, :advertisement_id
  end

  def self.down
    drop_table :ad_show_controls
  end
end
