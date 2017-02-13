module AdOwner
  def self.included(base)
    base.class_eval do 
      belongs_to :agent, :class_name=>'Party', :foreign_key=>'agent_id'
      belongs_to :sales, :class_name=>'Member', :foreign_key=>'sales_id'
      has_many :campaigns
      has_many :advertisements
    end
  end

  def stop_all!
    AdShowControl.connection.execute "delete from ad_show_controls where party_id = #{self.id}"
    AdShowControl.connection.execute "update publish_policies set status = #{PublishPolicy::STATUS_STOPPED} where status = #{PublishPolicy::STATUS_RUNNING} and campaign_id in (select id from campaigns c where c.party_id = #{self.id})"
  end
end
