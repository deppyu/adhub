class AddColumnToParties < ActiveRecord::Migration
  def self.up
    add_column :parties,:ad_maintained_by,:integer,:default=>0
  end

  def self.down
    remove_column :parties,:ad_maintained_by
  end
end
