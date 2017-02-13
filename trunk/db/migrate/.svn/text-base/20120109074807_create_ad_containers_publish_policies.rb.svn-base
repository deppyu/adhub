class CreateAdContainersPublishPolicies < ActiveRecord::Migration
  def self.up
    create_table :ad_containers_publish_policies, :id=>false, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true do |t|
      t.integer :ad_container_id, :null=>false
      t.integer :publish_policy_id, :null=>false
    end    
    add_index :ad_containers_publish_policies, [:ad_container_id, :publish_policy_id], 
              :unique=>true, :name=>'uidx_ad_containers_publish_policies'
  end

  def self.down
    drop_table :ad_containers_publish_policies
  end
end
