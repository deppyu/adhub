class CreateAdDailySummaries < ActiveRecord::Migration
  def self.up
    create_table :ad_daily_summaries, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :party_id
      t.integer :campaign_id
      t.integer :publish_policy_id
      t.integer :advertisement_id
      t.integer :impression_count, :null=>false, :default=>0
      t.integer :click_count, :null=>false, :default=>0
      t.decimal :used_budget, :null=>false, :default=>0, :scale=>4, :precision=>14
      t.date :summary_date, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_daily_summaries
  end
end
