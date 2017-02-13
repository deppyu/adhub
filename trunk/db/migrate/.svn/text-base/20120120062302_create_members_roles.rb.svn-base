class CreateMembersRoles < ActiveRecord::Migration
  def self.up
    create_table :members_roles, :id=>false, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
    	t.integer :member_id, :null=>false
    	t.integer :role_id, :null=>false
    end
    
    add_index :members_roles, [:member_id, :role_id], :unique=>true
  end

  def self.down
    drop_table :members_roles
  end
end
