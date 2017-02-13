class CreateSdks < ActiveRecord::Migration
  def self.up
    create_table :sdks, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :os_type, :null=>false
      t.integer :status, :null=>false
      t.string :name
      t.string :version
      t.string :file
      t.timestamps
    end
  end

  def self.down
    drop_table :sdks
  end
end
