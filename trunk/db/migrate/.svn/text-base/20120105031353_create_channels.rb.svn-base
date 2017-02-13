# encoding: UTF-8
class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.string :name, :null=>false, :limit=>30
      t.string :ad_container_name, :null=>false, :limit=>60
      t.timestamps
    end

  end

  def self.down
    drop_table :channels
  end
end
