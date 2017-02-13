class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.string :code, :null=>false, :limit=>15
      t.string :name, :null=>false, :limit=>60
    end
  end

  def self.down
    drop_table :roles
  end
end
