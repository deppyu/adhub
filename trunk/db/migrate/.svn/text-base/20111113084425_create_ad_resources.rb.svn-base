class CreateAdResources < ActiveRecord::Migration
  def self.up
    create_table :ad_resources, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :member_id, :null=>false
      t.integer :advertisement_id
      t.integer :width
      t.integer :height
      t.string :size_code, :limit=>30
      t.string :ad_format, :limit=>30
      t.string :name, :limit=>30
      t.string :text, :limit=>600
      t.string :file, :limit=>255
      t.string :file_content_type, :limit=>255
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_resources
  end
end
