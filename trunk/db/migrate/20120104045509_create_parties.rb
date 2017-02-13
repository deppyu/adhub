# -*- coding: undecided -*-
class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :agent_id
      t.integer :party_type, :null=>false, :default=>0 # 0: Company; 1: person
      t.boolean :adhub_operator, :null=>false, :default=>false
      t.string :name, :limit=>300, :null=>false
      t.string :address, :limit=>300
      t.string :phone_number, :limit=>50
      t.string :post_code, :limit=>6
      t.timestamps
    end
  end

  def self.down
    drop_table :parties
  end
end
