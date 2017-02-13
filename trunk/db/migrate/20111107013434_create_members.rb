class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.boolean :is_admin, :null=>false, :default=>false
      t.integer :status, :null=>false, :default=>0
      t.integer :party_id
      t.string :email, :limit=>255, :null=>false
      t.string :password_hash, :limit=>255, :null=>false
      t.string :ha1, :limit=>255, :null=>false
      t.string :real_name, :limit=>30, :null=>false
      t.string :activation_code, :limit=>32
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
