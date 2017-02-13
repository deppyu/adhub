class CreateApproveLogs < ActiveRecord::Migration
  def self.up
    create_table :approve_logs do |t|
      t.integer :member_id, :null=>false
      t.integer :target_id, :null=>false
      t.integer :result, :null=>false, :default=>0
      t.string :target_type, :null=>false, :limit=>1000
      t.string :opinion, :limit=>300
      t.timestamps
    end
  end

  def self.down
    drop_table :approve_logs
  end
end
