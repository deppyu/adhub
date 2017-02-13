class CreatePublisherDailySummaries < ActiveRecord::Migration
  def self.up
    create_table :publisher_daily_summaries, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :party_id, :null=>false, :default=>0, :option=>'CONSTRAINT FK_PUB_DAILY_SUM_PARTY REFERENCES parties(id)'
      t.integer :ad_container_id, :null=>false, :default=>0, :option=>'CONSTRAINT FK_PUB_DAILY_SUM_AD_CONTAINER REFERENCES ad_containers(id)'
      t.integer :request_count, :null=>false, :default=>0
      t.integer :shown_count, :null=>false, :default=>0
      t.integer :click_count, :null=>false, :default=>0
      t.integer :fulfill_count, :integer, :null=>false, :default=>0
      t.date :summary_date, :null=>false
      t.decimal :income, :scale=>4, :precision=>14, :default=>0, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :publisher_daily_summaries
  end
end
