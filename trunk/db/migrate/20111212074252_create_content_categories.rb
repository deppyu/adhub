# encoding: UTF-8
class CreateContentCategories < ActiveRecord::Migration
  def self.up
    create_table :content_categories, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.boolean :for_ad_container, :null=>false, :default=>true # 是否用于广告容器
      t.boolean :for_advertisement, :null=>false, :default=>true # 是否用于广告
      t.string :name, :limit=>30, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :content_categories
  end
end
