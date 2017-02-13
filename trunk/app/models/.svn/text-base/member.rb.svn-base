require 'digest'

class Member < ActiveRecord::Base
  STATUS_REGISTERED = 0
  STATUS_ACTIVE = 1
  STATUS_LOCKED = 2
  
  ALL_STATUS = [STATUS_REGISTERED,STATUS_ACTIVE,STATUS_LOCKED]
  
  has_password :password, :password_hash, :ha1, Adhub::HTTP_DIGEST_REALM
  has_and_belongs_to_many :roles
  belongs_to :party

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_length_of :email, :maximum=>255
  validates_presence_of :real_name
  validates_length_of :real_name, :maximum=>30
    
  def self.login(email, password)
    self.find_by_email_and_password_hash email, Imon::ActiveRecord::Password::encrypt(password)
  end

  def digest
    Digest::MD5.hexdigest("#{self.login_name}:#{self.password_hash}")
  end

  def login_name
    self.email
  end

  def generate_activation_code
    self.activation_code = Digest::MD5.hexdigest("#{self.email}:#{Adhub::HTTP_DIGEST_REALM}:#{rand}")
  end

  def active!
    self.update_attribute :status, STATUS_ACTIVE
  end

  def active?
    STATUS_ACTIVE == self.status
  end

  def pay!(amount)
    Member.connection.execute "update members set account_balance = account_balance - #{amount} where id = #{self.id}"
    self.reload
    self.stop_all! if self.account_balance <= 0
  end

  def stop_all!
    self.campaigns.each do |c| 
      c.stop! 
    end
  end
  
  def reset_passwd
    self.password = Imon::ActiveRecord::Password::generate
    self.save!
    self.password
  end

  def new_passwd
    self.password = Imon::ActiveRecord::Password::generate
    self.password
  end
  
  def set_is_publisher!
    self.update_attribute :is_publisher, true
  end

  def label
    self.name or self.email
  end

  def is_ad_owner
    return (self.party and self.party.is_valid_ad_owner?)
  end

  def is_publisher
    return (self.party and self.party.is_valid_publisher?)
  end

  def is_agent
    return (self.party and self.party.is_valid_agent?)
  end
  
  def is_sales
    return self.has_role?(:sales)
  end
  
  def has_many_ad_owners?
    return  self.delegated_ad_owners.size > 1
  end

  def has_role?(role)
    if role.is_a? Role
      self.roles.include? role
    else
      self.role_names.include? role.to_s.to_sym
    end
  end
  
  def delegated_ad_owners
    valid_ad_owners = []
    valid_ad_owners[0] = self.party if self.party and self.party.is_valid_ad_owner? and self.has_role?(:ad_owner)
    if self.party.is_valid_agent?
      if self.is_sales
        ad_owners_for_sales = Party.where(:sales_id=>self.id,:ad_maintained_by=>Party::AD_MAINTAINED_BY_SALES)
        valid_ad_owners.concat ad_owners_for_sales
      end
      if self.has_role?(:agent)
        ad_owners_for_agent = Party.where(:ad_maintained_by=>Party::AD_MAINTAINED_BY_ADMIN)
        valid_ad_owners.concat ad_owners_for_agent
      end
    end
    return valid_ad_owners
  end
  
  def has_manager_privilege?(party)
      if party.is_a?(Party)
         return self.party.id == party.agent_id || (self.id == party.sales_id and party.ad_maintained_by == Party::AD_MAINTAINED_BY_SALES) ||
                (self.is_admin == 1 && party.ad_maintained_by == Party::AD_MAINTAINED_BY_ADMIN)
      end
      return false
  end
  
  def role_names
    names = []
    if self.party
      valid_roles = self.roles.find_all { 
        |r| r.required_contract_type.nil? or self.party.has_valid_contract_for(r.required_contract_type) 
      }
      names = valid_roles.collect { |role| role.code.to_sym }
      names << :super_admin if self.is_admin and self.party and self.party.adhub_operator
    end #if self.party
    names << :member
    names
  end
end
