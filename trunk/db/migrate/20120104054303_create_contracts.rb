class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :business_type, :default=>0, :null=>false
      t.integer :party_id, :null=>false
      t.boolean :expiration_processed, :default=>false, :null=>false
      t.date :start_from, :null=>false
      t.date :expired_at, :null=>false
      t.string :contact_person, :null=>false, :limit=>60
      t.string :mobile_phone, :null=>false, :limit=>20
      t.timestamps
    end
  end

  def self.down
    drop_table :contracts
  end
end
