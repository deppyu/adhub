# encoding: UTF-8
class Advertisement < ActiveRecord::Base
  STATUS_EDITING = 0 # 编辑中
  STATUS_SUBMITTED = 1 # 提交审核
  STATUS_APPROVED = 2 # 审核通过
  STATUS_DISAPPROVED = 3 # 审核未通过
  # STATUS_PAUSED = 4 # 停止，暂停
  
  ALL_STATUS = [STATUS_EDITING,STATUS_SUBMITTED,STATUS_APPROVED,STATUS_DISAPPROVED] # ,STATUS_PAUSED]
  
#  belongs_to :ad_group
  belongs_to :party
  has_many :ad_resources
  has_many :ad_show_controls
  has_many :approve_logs, :as=>:target
  has_many :publish_policies
  has_one :black_list, :as=>:black_member

#  serialize :call_to_action_params

  validates_presence_of :name
  validates_length_of :name, :maximum=>40
  validates_presence_of :ad_format

  scope :of_status, lambda { |t| where :status=>t }
  scope :effective, where(:status=>STATUS_APPROVED)

  def ad_format
    @ad_format = AdFormat.of_name self['ad_format'] if @ad_format.nil?
    @ad_format
  end

  def ad_format=(format)
    self['ad_format'] = format.is_a?(AdFormat) ? format.name : format.to_s
  end

  def reach_rate
    return 0 if 0 == impression_count
    click_count * 100.to_f  / impression_count.to_f
  end

  def resource_of_name(name)
    self.ad_resources.find_by_name name
  end

  def resource_of_size(size)
    self.ad_resources.find_by_size_code size
  end

  def waiting_submit_approve?
    [STATUS_EDITING, STATUS_DISAPPROVED].include? self.status
  end

  def submit_approve!
    self.update_attribute :status, STATUS_SUBMITTED if waiting_submit_approve?
  end

  def editable?
    [STATUS_EDITING, STATUS_DISAPPROVED].include? self.status
  end

  def waiting_approve?
    STATUS_SUBMITTED == self.status
  end

  def approve!(result)
    if self.waiting_approve?
      if ApproveLog::APPROVE == result
        update_attribute :status, STATUS_APPROVED
      else
        update_attribute :status, STATUS_DISAPPROVED
      end
    end
  end

  def calculate_weight
    return Advertisement.compare_price(self.ad_group.bid_price, self.ad_group.pay_method_id) / 4.0 + 1
  end

  def size_codes
    if self.ad_format
     return nil if self.ad_format.variable_size
    end
    codes = self.ad_resources.collect { |r| "'#{r.size_code}'" }
    codes.uniq.join()
  end
  
  def destroyable?
    self.editing? and 0 == self.impression_count
  end

  def pay_on_shown?
    self.ad_group.pay_method.pay_on_show?
  end

  def stoped?
    self.publish_policies.each do |pp|
      puts "#{pp}.stopped? #{pp.stopped?}"
      return false unless pp.stopped?
    end
    return true
  end
  
  def shown!
    Advertisement.increment_counter :impression_count, self.id
  end

  def clicked!
    Advertisement.increment_counter :click_count, self.id
  end

  def stop!
    stop_process
  end

  def running?
    return ! stoped?
  end
  
  def runnable
    return self.status == Advertisement::STATUS_APPROVED && self.publish_policies.count >= 0
  end

  def revokable?
    STATUS_APPROVED == status
  end

  def revoke!
    self.transaction do
      stop_process
      self.update_attribute :status, STATUS_EDITING if self.revokable?
    end
  end

  def editing?
    STATUS_EDITING == self.status
  end

  def paused?
    return self.stoped?
  end

  def approved?
    STATUS_APPROVED == self.status
  end

  def execute!
    if self.approved? and self.has_effective_publish
      self.transaction do
        self.publish_policies.each do |pp|
          pp.execute!
        end
      end
    end
  end

  def has_effective_publish
    self.publish_policies.effective.count > 0
  end

  def publish_to(options)
    pp = self.publish_policies.build options.merge({:status=>PublishPolicy::STATUS_STOPPED})
    pp.save!
    pp
  end

  private
  def stop_process
    self.publish_policies.each { |pp| pp.stop! }
  end
  
  def create_show_control!
    self.publish_policies.each { |pp| pp.create_show_control! }
  end
end
