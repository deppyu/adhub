# -*- coding: utf-8 -*-
class Campaign < ActiveRecord::Base
  belongs_to :party
#  has_many :ad_groups
  has_many :publish_policies
  has_many :advertisements, :through=>:publish_policies
  validates_presence_of :name
  validates_length_of :name, :maximum=>40
  validates_presence_of :budget
  validates_numericality_of :budget, :greater_than_or_equal_to=>100
  validates_presence_of :daily_budget
  validates_numericality_of :daily_budget, :greater_than_or_equal_to=>10
  validates_presence_of :start_from
  validates_length_of :description, :maximum=>250


  def remain_budget
    self.budget - self.used_budget
  end

  def impression_count
    self.advertisements.sum :impression_count #, :conditions=>['ad_group_id in (select id from ad_groups where campaign_id = ?)', self.id]
  end

  def click_count
    self.advertisements.sum :impression_count #, :conditions=>['ad_group_id in (select id from ad_groups where campaign_id = ?)', self.id]
  end

  def total_ad_count
    self.publish_policies.count
  end

  def effective_ad_count
    self.publish_policies.running.count
  end

  def used_daily_budget
    AdRequest.used_daily_budget_for_campaign(self)
  end
  
  def remain_daily_budget
    return nil unless self.daily_budget
    self.daily_budget - self.used_daily_budget
  end

  # 每日预算的剩余部分是否超过amount
  def has_daily_budget_for(amount)
    return (self.daily_budget.nil? or self.remain_daily_budget >= amount)
  end

  def use_budget!(amount)
    Campaign.connection.execute "update campaigns set used_budget = used_budget + #{amount} where id = #{self.id}"
    self.reload
    puts "budget: #{self.budget}, used budget: #{self.used_budget}, remain_budget: #{self.remain_budget}"
    self.stop! if self.remain_budget <= 0
  end

  def running?
    return false if self.ended?
    
    return true
  end

  def stop!
    self.publish_policies.each { |pp| pp.stop! }
  end

  def execute!
    self.ad_groups.each { |g| g.execute! }
  end

  def submit!
    self.ad_groups.each { |g| g.submit! }
  end

  def paused?
     
  end

  def ended?
    return (self.end_to and (Date.today + 1 > self.end_to))
  end

  def destroyable?
    
  end

  def waiting_submit_approve?

  end

  def total_daily_budget_of_publish_policies
    self.publish_policies.sum(:daily_budget)
  end

  def total_budget_for_publish_policies
    self.publish_policies.inject(0) { |sum, publish_policy| sum + (publish_policy.total_budget || 0) } 
  end
end
