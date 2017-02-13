# encoding: UTF-8

class AdGroup < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :pay_method
  has_many :advertisements
#  has_and_belongs_to_many :content_categories

  validates_presence_of :name
  validates_length_of :name, :maximum=>40
  validates_presence_of :call_to_action
  validates_presence_of :pay_method
  validates_presence_of :start_from

  scope :created, where(:creating=>false)

  # Return how many advertisements with same pay method has lower price, in percentage
  def validate
    errors.add :bid_price, '不能低于最低价。' unless bid_price >= self.pay_method.base_price unless creating
    errors.add :end_to, '不能早于开始时间。' unless end_to.nil? or end_to > start_from
    errors.add :start_from, '不能早于广告活动的开始时间。'  unless start_from >= campaign.start_from
    errors.add :end_to, '不能晚于广告活动的结束时间。' unless end_to.nil? or end_to <= campaign.end_to
  end

  def effective_ad_count
    self.advertisements.of_status(Advertisement::STATUS_APPROVED).count
  end

  def impression_count
    self.advertisements.sum :impression_count
  end

  def click_count
    self.advertisements.sum :click_count
  end

  def used_budget
    self.advertisements.sum :used_budget
  end

  def used_daily_budget
    AdRequest.used_daily_budget_for_ad_group(self)
  end

  # 到达率
  def reach_rate
    return 0 if 0 == impression_count
    click_count * 100.to_f  / impression_count.to_f
  end

  def call_to_action
    @call_to_action = CallToAction.of_name self['call_to_action'] if @call_to_action.nil?
    @call_to_action
  end

  def call_to_action=(call_to_action)
    self['call_to_action'] = call_to_action.is_a?(CallToAction) ? call_to_action.name : call_to_action.to_s
  end
  
  def unit_price
    self.bid_price / self.pay_method.unit.to_f if self.bid_price and self.pay_method.unit
  end
  
  def paused?
    self.advertisements.each do |ad|
      return true if ad.paused?
    end
    return false
  end

  def running?
    self.advertisements.each do |ad|
       return true if ad.running?
    end
    return false
  end
  
  def revokable?
    flag = true
    self.advertisements.each do |ad|
       unless ad.revokable?
          flag = false
       end
    end
    return flag 
  end
  
  def execute!
    self.advertisements.each do |ad|
      ad.execute!
    end
  end
  
  def revoke!
    if self.revokable?
      self.advertisements.each do |ad|
        ad.revoke!
      end
    end
  end
  
  def submit!
    self.advertisements.each do |ad|
      ad.submit_approve!
    end
  end

  def destroyable?
    return true if self.advertisements.empty?
    self.advertisements.each do |a|
      unless a.destroyable?
        return false
      end
    end
    return true
  end
  
  def stop!
    self.advertisements.effective.each { |ad| ad.stop! }
  end

  def waiting_submit_approve?
    self.advertisements.each do |a|
      return true if a.waiting_submit_approve?
    end
    return false
  end

  def expect_effect
    (daily_budget / self.bid_price * pay_method.unit).to_i if self.bid_price
  end

  def day_number
    return nil if self.end_to.nil?
    (self.end_to - self.start_from).to_i
  end

  def total_budget
    return nil if self.day_number.nil? or self.daily_budget.nil?
    self.day_number * self.daily_budget
  end

  def has_content_category(cat)
    self.content_category_ids.include? cat.id
  end

end

