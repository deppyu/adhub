# require 'Contract'

module Publisher
  def self.included(base)
    base.class_eval do 
      has_many :prices
      has_many :ad_containers
      has_many :black_lists
    end
  end

  def base_price(channel, pay_method, ad_owner)
    # puts "Called base_price on #{self.id}"
    # puts "ad_owner's agent is #{ad_owner.agent}"
    # puts "#{publisher_self_ad_owner(ad_owner)}"
    return 0 if self == ad_owner
    return Party.adhub_operator.base_price channel, pay_method, ad_owner unless self.adhub_operator or publisher_self_ad_owner(ad_owner)
    price = self.prices.where(:party_id=>self.id, :channel_id=>(channel ? channel.id : nil), :pay_method_id=>pay_method.id).first
    if ! price.nil?
      price.base_price
    elsif self.adhub_operator 
      if channel
        self.base_price(nil, pay_method, ad_owner)
      else
        0
      end
    else
      Party.adhub_operator.base_price channel, pay_method, ad_owner
    end
  end

  def publisher_self_ad_owner(ad_owner)
    self == ad_owner.agent
  end

  def share_rate_for_own_customer
    share_rate Contract::BUSINESS_TYPE_PUBLISHER, :share_rate_1, SystemParameter::PUBLISHER_SHARE_RATE_FOR_OWNER_CUSTOMER
  end

  def share_rate_for_other_customer
    share_rate Contract::BUSINESS_TYPE_PUBLISHER, :share_rate_2, SystemParameter::PUBLISHER_SHARE_RATE_FOR_OTHER_CUSTOMER
  end


end
