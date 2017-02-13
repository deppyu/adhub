class Party < ActiveRecord::Base
  has_many :members
  has_many :contracts
  has_many :bank_accounts
  has_one :account
  has_one :black_list, :as=>:black_member
  has_many :approve_log, :as=>:target

  PARTY_TYPE_COMPANY=0
  PARTY_TYPE_PERSON=1
  ALL_PARTY_TYPE = [PARTY_TYPE_COMPANY, PARTY_TYPE_PERSON]
  
  AD_MAINTAINED_BY_CUSTOMER = 0
  AD_MAINTAINED_BY_SALES = 1
  AD_MAINTAINED_BY_ADMIN = 2
  ALL_AD_MAINTAINED_BY = [AD_MAINTAINED_BY_CUSTOMER,AD_MAINTAINED_BY_SALES,AD_MAINTAINED_BY_ADMIN]

  include Publisher
  include AdOwner
  include Agent
  
  validates_presence_of :name
  validates_presence_of :party_type
  validates_presence_of :address
  validates_presence_of :phone_number
  validates_presence_of :post_code
  validates_uniqueness_of :name

  def self.adhub_operator
    self.where(:adhub_operator=>true).first
  end

  def is_valid_agent?
    self.adhub_operator or self.has_valid_contract_for Contract::BUSINESS_TYPE_AGENT
  end

  def is_valid_publisher?
    self.adhub_operator or self.has_valid_contract_for Contract::BUSINESS_TYPE_PUBLISHER    
  end

  def is_valid_ad_owner?
    self.adhub_operator or self.has_valid_contract_for Contract::BUSINESS_TYPE_AD_OWNER        
  end
  
  def has_valid_contract_for(business_type)
    self.adhub_operator or self.contracts.of_business_type(business_type).valid.count == 1
  end

  def valid_contracts
    self.contracts.valid
  end

  def available_roles
    return Role.all if self.adhub_operator
    valid_contract_types = self.valid_contracts.collect { |c| c.business_type }
    Role.available_to_contract_types valid_contract_types
  end

  def account_balance
    self.create_account if self.account.nil?
    self.account.balance
  end

  def sales_email
    if self.sales_id
      return member.find(self.sales_id).email
    else
      nil
    end
  end

  def contract_of(business_type)
    self.contracts.of_business_type(business_type).first
  end

  def destroyable?
    self.contracts.count ==0
  end

  def balance_warn_parties
    if self.ad_owners.count > 0
      self.ad_owners.where("id in (select party_id from accounts where balance <= #{Contract::BALANCE_WARN} order by balance) and id not in (select party_id from contracts where expiration_processed = 1)")
    end
  end

  def expired_warn_parties
    if self.ad_owners.count > 0
      self.ad_owners.where("id in (select party_id from contracts where expiration_processed = 0 and TIMESTAMPDIFF(DAY, now(), expired_at) <= #{Contract::EXPIRED_WARN} order by expired_at)")
    end
  end

  alias_method :old_account, :account

  def account
    if self.old_account.nil?
      # puts "self(Party[#{self}, #{self.id}]).old_account is nil, create new one"
      self.create_account
    end
    self.old_account
  end

  def can_archived?
    self.contracts.where(:expiration_processed=>false).count == 0 and !self.archived
  end

  def has_enough_balance_to_run_ad
    self.account.balance > 100
  end
  
  private
  def share_rate(business_type, attribute, system_param)
    contract = self.contract_of business_type
    return 0 if contract.nil?
    rate = contract.send attribute
    if rate and rate > 0
      rate
    else
      SystemParameter.find_by_name(system_param).value
    end
  end

  # def create_account
  #   return self.account if self.account
  #   self.create_account :balance=>0
  # end
end
