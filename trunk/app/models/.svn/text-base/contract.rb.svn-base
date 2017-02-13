class Contract < ActiveRecord::Base
  BUSINESS_TYPE_PUBLISHER = 0
  BUSINESS_TYPE_AGENT = 1
  BUSINESS_TYPE_AD_OWNER = 2

  ALL_BUSINESS_TYPE=[BUSINESS_TYPE_PUBLISHER, BUSINESS_TYPE_AGENT, BUSINESS_TYPE_AD_OWNER]

  BALANCE_WARN = 100
  EXPIRED_WARN = 30

  belongs_to :party

  validates_presence_of :business_type
  validates_presence_of :start_from
  validates_presence_of :expired_at
  validates_presence_of :contact_person
  validates_presence_of :mobile_phone

  scope :of_business_type, lambda { |bt| where(:business_type => bt) } 
  scope :valid, where('expired_at >= ? ', Date.today)

  def stop!
    self.expiration_processed = true
    self.expired_at = Date.today - 1
    self.save!
  end
end
