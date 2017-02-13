class CreateBlackLists < ActiveRecord::Migration
  def self.up
    create_table :black_lists do |t|
      t.integer :party_id, :null=>false
      t.integer :black_member_id, :null=>false
      t.string :black_member_type, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :black_lists
  end
end
