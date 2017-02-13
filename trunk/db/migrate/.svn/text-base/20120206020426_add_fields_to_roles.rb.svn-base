class AddFieldsToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :required_contract_type, :integer
    add_column :roles, :note, :string, :limit=>300
  end

  def self.down
    remove_column :roles, :required_contract_type
    remove_column :roles, :note
  end
end
