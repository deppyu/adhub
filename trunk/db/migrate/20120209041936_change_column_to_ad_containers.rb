class ChangeColumnToAdContainers < ActiveRecord::Migration
  def self.up
      change_column :ad_containers, :type, :string, :limit=>255, :null=>true
  end

  def self.down
  end
end
