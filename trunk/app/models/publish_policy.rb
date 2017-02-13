# encoding: UTF-8
class PublishPolicy < ActiveRecord::Base
  STATUS_CREATING = 0
  STATUS_CREATED = 1
  STATUS_STOPPED = 2
  STATUS_RUNNING = 3

  belongs_to :campaign
  belongs_to :advertisement
  belongs_to :pay_method
  belongs_to :channel
  has_one :ad_show_control
  has_and_belongs_to_many :content_categories
  has_and_belongs_to_many :ad_containers
  serialize :call_to_action_params

  validates_presence_of :name
  validates_length_of :name, :maximum=>40
  validates_presence_of :call_to_action
  validates_presence_of :pay_method
  validates_presence_of :start_from

  scope :effective, where('(end_to is null or end_to >= ?) and status <> ? ', Date.today, STATUS_CREATING)
  scope :running, where('(end_to is null or end_to >=? ) and status = ?', Date.today, STATUS_RUNNING)
  scope :of_channel, Proc.new { |c| where(:channel_id=>c.id) }
  scope :of_pay_method, Proc.new { |pm| where(:pay_method_id=>pm.id) }
  scope :created, where('status <> ?', STATUS_CREATING)

  def create_show_control
    self.build_ad_show_control :party=>self.campaign.party, 
                               :publish_policy=>self, 
                               :campaign=>self.campaign, 
                               :advertisement => self.advertisement,
                               :channel=>self.channel,
                               :unit_price=>self.unit_price, :begin=>self.start_from, :end=>self.end_to, 
                               :ad_format=>self.advertisement.ad_format, :size_codes=>self.advertisement.size_codes, 
                               :weight=>self.calculate_weight, 
                               :content_categories => self.content_category_ids_for_show_control,
                               :ad_containers => self.ad_container_ids_for_show_control
  end

  def unit_price
    self.bid_price / self.pay_method.unit
  end

  def create_show_control!
    ctrl = self.create_show_control
    ctrl.save!
    ctrl
  end

  def calculate_weight
    total = PublishPolicy.count :conditions=>['channel_id = ? and start_from <= ? and (end_to is null or end_to >= ?) and publish_policies.status <> ? and advertisements.status = ?', self.channel_id, Date.today, Date.today, STATUS_CREATING, Advertisement::STATUS_APPROVED], :include=>:advertisement
    return 1 if 0 == total
    low = PublishPolicy.count :conditions=>['bid_price < ? and channel_id = ? and start_from <= ? and (end_to is null or end_to >= ?) and publish_policies.status <> ? and  advertisements.status = ?', 
                                              self.bid_price, self.channel_id, Date.today, Date.today, STATUS_CREATING,
                                              Advertisement::STATUS_APPROVED], :include=>:advertisement

    return 1 - low.to_f / total.to_f
  end

  def content_category_ids_for_show_control
    return nil if self.content_categories.empty?
    (self.content_category_ids.collect { |id| "'#{id}'" }).join()
  end

  def ad_container_ids_for_show_control
    return nil if self.ad_containers.empty?
    (self.ad_container_ids.collect { |id| "'#{id}'" }).join()
  end

  def used_daily_budget
    AdRequest.used_daily_budget_for_publish_policy(self)
  end

  # "每日预算"的剩余部分是否超过amount
  def has_daily_budget_for(amount)
    return (self.daily_budget.nil? or (self.daily_budget - self.used_daily_budget) >= amount)
  end

  def call_to_action
    @call_to_action = CallToAction.of_name self['call_to_action'] if @call_to_action.nil?
    @call_to_action
  end

  def call_to_action=(call_to_action)
    self['call_to_action'] = call_to_action.is_a?(CallToAction) ? call_to_action.name : call_to_action.to_s
    @call_to_action = CallToAction.of_name self['call_to_action']
  end

  def call_to_action_param(param)
    return nil if self.call_to_action_params.nil?
    call_to_action_params[param.name.to_s]
  end

  def pay!(unit_price)
    self.advertisement.party.account.withdraw!(unit_price)
    self.campaign.use_budget! unit_price
    PublishPolicy.connection.execute "update publish_policies set used_budget = used_budget + #{unit_price} where id = #{self.id}"
  end

  def created!
    self.update_attributes :status=>STATUS_STOPPED if self.creating?
  end

  def execute!
    return if self.running? or self.creating? or self.expired?
    self.transaction do
      self.update_attribute :status, STATUS_RUNNING
      self.create_show_control!
    end
  end

  def expired?
    return (self.end_to and self.end_to < Date.today)
  end

  def running?
    STATUS_RUNNING == self.status
  end

  def stopped?
    return ! self.running?
  end

  def creating?
    STATUS_CREATING == self.status
  end

  def stop!
    puts "PublishPolicy#stop!: publish_policy#stop! status = #{self.status}"
    return unless self.running?
    self.transaction do
      # puts "publish_policy#stop! change status now."
      self.update_attribute :status, STATUS_STOPPED
      puts "publish_policy#stop! status after change #{self.status}"
      if self.ad_show_control
        self.ad_show_control.destroy 
        self.ad_show_control = nil
      end
    end
  end

  def determine_base_price
    puts "I have #{self.ad_containers.count} ad_containers"
    unless self.ad_containers.empty? or publish_to_different_publisher?
      puts "Publish to only one publisher: #{self.ad_containers.first}"
      self.ad_containers.first.party.base_price self.channel, self.pay_method, self.advertisement.party
    else
      puts "Publish to more than one publisher"
      Party.adhub_operator.base_price self.channel, self.pay_method, self.advertisement.party
    end
  end

  # 发布到同一渠道，计费方式相同的广告中，本发布的竞价所排的位置。返回值表示竞价低于这个publish_policy的广告发布的比例。
  # 返回1表示出价最高。返回0.5表示价格超过了50%的其它广告发布。其余类推。返回0表示出价最低。
  def price_rank
    candidate_policies = PublishPolicy.running.of_channel(self.channel).of_pay_method(self.pay_method).where('id <> ?', self.id)
    total_count = candidate_policies.count
    return 1 if total_count == 0
    lower_count = candidate_policies.count :conditions=>['bid_price < ?',self.bid_price]
    lower_count.to_f / total_count.to_f
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

  private
  def publish_to_different_publisher?
    party_ids = (self.ad_containers.collect { |ac| ac.party_id }).uniq
    puts "publish to #{party_ids.size} publishers"
    party_ids.size > 1
  end
end
