class CreateAdContainers < ActiveRecord::Migration
  def self.up
    create_table :ad_containers, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :party_id, :null=>false
      t.integer :channel_id
      t.integer :os_type
      t.integer :status
      t.integer :request_count, :default=>0
      t.integer :show_count, :default=>0
      t.integer :click_count, :default=>0
      t.decimal :latitude, :scale=>12, :precision=>15
      t.decimal :longitude, :scale=>12, :precision=>15
      t.decimal :income, :scale=>4, :precision=>14, :default=>0, :null=>false
      t.string :type, :limit=>50
      t.string :name, :null=>false, :limit=>120
      t.string :url, :limit=>512
      t.string :identity, :limit=>100, :null=>false
      t.string :description, :limit=>2100
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_containers
  end
end
