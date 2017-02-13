class AddArchivedToParties < ActiveRecord::Migration
  def self.up
    add_column :parties, :archived, :boolean, :default=>false
  end

  def self.down
    remove_column :parties, :archived
  end
end
