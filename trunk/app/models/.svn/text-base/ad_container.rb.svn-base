# encoding: UTF-8
class AdContainer < ActiveRecord::Base
  OS_ANDROID=0

  STATUS_EDITING = 0 # 编辑中 
  STATUS_ACTIVE = 1 # 审核通过
  STATUS_LOCKED = 2  # 被锁定
  STATUS_DISAPPROVED = 3 # 提交审核

  IDENTITY_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

  has_many :approve_logs, :as=>:target

  validates_presence_of :name
  validates_length_of :name, :maximum=>40
  validates_length_of :description, :maximum=>700
  validates_uniqueness_of :name, :scope=>'party_id'
  validates_presence_of :party_id
  validates_presence_of :income

  belongs_to :party
  belongs_to :channel
  has_and_belongs_to_many :content_categories
  has_and_belongs_to_many :publish_policies
  
  def before_create
    self.identity = generate_identity
  end

  def after_create
    self.party.is_valid_publisher?
  end

  def active?
    STATUS_ACTIVE == self.status
  end

  def income!(amount)
    self.connection.execute "update ad_containers set income = income + #{amount} where id = #{self.id}"
    self.party.account.save! amount
  end
  
  private
  def generate_identity
    # TODO: used uuid instead
    l = IDENTITY_CHARS.length
    found = false
    while ! found do
      idt = ''
      20.times {  idt << IDENTITY_CHARS[rand(l)] }
      found = (AdContainer.where(:identity=>idt).count == 0)
      return idt if found
    end
  end
  
  def self.find_party_id(party)
    party_id = AdContainer.find_by_sql("select id from parties p where name like '%#{party}}%'")
    return party_id
  end
end
