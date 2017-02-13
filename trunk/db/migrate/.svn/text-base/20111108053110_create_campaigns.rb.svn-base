class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :party_id, :null=>false
      t.date   :start_from, :null=>false
      t.date   :end_to
      t.decimal :budget, :null=>false, :scale=>2, :precision=>12, :default=>0
      t.decimal :used_budget, :null=>false, :scale=>5, :precision=>15, :default=>0
      t.decimal :daily_budget, :scale=>2, :precision=>12
      t.string :name, :null=>false, :limit=>300
      t.string :description, :limit=>750
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
