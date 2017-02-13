class NoEnoughBalance < Exception
end

class AdShowControl < ActiveRecord::Base
  belongs_to :party
  belongs_to :advertisement
  belongs_to :campaign
  belongs_to :publish_policy
  belongs_to :channel
  
  def ad_format
    @ad_format = AdFormat.of_name self['ad_format'] if @ad_format.nil?
    @ad_format
  end

  def ad_format=(format)
    self['ad_format'] = format.is_a?(AdFormat) ? format.name : format.to_s
  end

  def check_balance
    return (self.party.account.balance > 0 and self.campaign.budget > self.campaign.used_budget)
  end

  def check_daily_budget
    return false unless self.publish_policy.has_daily_budget_for(self.unit_price)
    return false unless self.campaign.has_daily_budget_for(self.unit_price)
    true
  end
end
