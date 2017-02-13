module AdOwner::ConsoleHelper
  # TODO implement all count methods
  # def ad_group_count
  #  AdGroup.count :include=>:campaign, :conditions=>['campaigns.member_id = ?', current_user.id]
  # end

  def ad_count
    current_user.party.campaigns.inject(0) { |sum, c| sum + c.total_ad_count }
  end

  def effective_ad_count
    current_user.party.campaigns.inject(0) { |sum, c| sum + c.effective_ad_count }    
  end

  def click_count
    current_user.party.campaigns.inject(0) { |sum, c| sum + c.click_count }    
  end

  def impression_count
    current_user.party.campaigns.inject(0) { |sum, c| sum + c.impression_count }    
  end
end
