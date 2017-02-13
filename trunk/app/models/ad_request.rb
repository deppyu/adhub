class AdRequest < ActiveRecord::Base
  belongs_to :publisher, :class_name=>'Party', :foreign_key=>'publisher_id'
  belongs_to :ad_owner, :class_name=>'Party', :foreign_key=>'ad_owner_id'
  belongs_to :agent, :class_name=>'Party', :foreign_key=>'agent_id'
  belongs_to :ad_container
  belongs_to :advertisement
  belongs_to :campaign
  belongs_to :publish_policy
  belongs_to :pay_method

  scope :of_publish_policy, lambda { |pp_id| where(:publish_policy_id=>pp_id) }
  scope :of_campaign, lambda { |cid| where(:campaign_id=>cid) }
  scope :paid, where(:paid=>true)
  scope :of_today, where(:request_date=>Date.today)

  def before_create
    self.request_date = Date.today if request_date.nil?
  end

  def after_create
    AdContainer.increment_counter :request_count, self.ad_container_id
  end

  def self.used_daily_budget_for_publish_policy(policy)
    self.of_publish_policy(policy.id).of_today.paid.sum(:unit_price) || 0
  end

  def self.used_daily_budget_for_campaign(campaign)
    self.of_campaign(campaign.id).of_today.paid.sum(:unit_price) || 0
  end

  def self.daily_request_count_of_publisher(publisher)
    self.of_today.where(:publisher_id=>publisher.id).count
  end

  def self.daily_shown_count_of_publisher(publisher)
    self.of_today.where(:shown=>true, :publisher_id=>publisher.id).count
  end

  def self.daily_click_count_of_publisher(publisher)
    self.of_today.where(:clicked=>true, :publisher_id=>publisher.id).count
  end

  def self.daily_income_of_publisher(publisher)
    self.of_today.where(:paid=>true, :publisher_id=>publisher.id).sum(:unit_price)
  end

  def show_control=(show_control)
    unless show_control.nil?
      self.unit_price = show_control.unit_price
      publish_policy = show_control.publish_policy
      self.pay_method = publish_policy.pay_method
      self.advertisement = publish_policy.advertisement
      self.publish_policy = publish_policy
      self.campaign = publish_policy.campaign
      self.ad_owner = self.advertisement.party
      self.agent = self.ad_owner.agent
      self.publisher_share_rate = self.ad_owner.agent == self.publisher ? self.publisher.share_rate_for_own_customer : self.publisher.share_rate_for_other_customer
      if (self.agent && self.agent != Party.adhub_operator)
        self.agent_share_rate = self.agent.agent_share_rate
      else
        self.agent_share_rate = 0
      end
      unit_price = show_control.unit_price
      self.fulfilled = true
    else
      self.fulfilled = false
    end
  end

  def to_show_publish_policy=(publish_policy)
  end

  def settlement
    self.transaction do 
      self.publish_policy.pay! self.unit_price
      self.ad_container.income! self.unit_price * publisher_share_rate
      adhub_operator = Party.adhub_operator
      puts "adhub_operator is #{adhub_operator}(#{adhub_operator.id}), account.id is #{adhub_operator.account.id}"
      self.agent.account.save! self.unit_price * (1 - publisher_share_rate) * agent_share_rate if self.agent
      adhub_operator.account.save! self.unit_price * (1 - publisher_share_rate) * (1 - agent_share_rate)
      self.update_attribute :paid, true
    end
  end

  def shown!
    return if self.shown
    if self.advertisement
      self.advertisement.shown!
      if self.pay_method.pay_on_show?
        self.settlement
        # self.publish_policy.pay! self.unit_price
        # publisher_rate = SystemParameter.find_or_create('publisher_share_rate', SystemParameter::FLOAT_PARAM).value
        # self.ad_container.income! self.unit_price * publisher_rate
        self.ad_owner.reload
        self.ad_owner.stop_all! if self.ad_owner.account.no_balance?
      end
      self.update_attributes! :shown=>true, :paid=>true
      AdContainer.increment_counter :show_count, self.ad_container_id
    end
  end

  def clicked!
    return if self.clicked
    self.shown! unless self.shown
    if self.advertisement
      self.advertisement.clicked!
      if self.pay_method.pay_on_click?
        self.publish_policy.pay! self.unit_price
        publisher_rate = SystemParameter.find_or_create('publisher_share_rate', SystemParameter::FLOAT_PARAM).value
        self.ad_container.income! self.unit_price * publisher_rate        
      end
      update_attributes! :clicked => true, :paid=>true
      AdContainer.increment_counter :click_count, self.ad_container_id
    end
  end

end
