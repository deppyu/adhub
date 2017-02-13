class Role < ActiveRecord::Base
  ROLE_ADMIN = 1
  ROLE_PUBLISHER = 2
  ROLE_AD_OWNER = 3
  ROLE_AGENT = 4
  ROLE_SALES = 5

  scope :available_to_contract_types, 
        Proc.new { |types| where('required_contract_type is null or required_contract_type in (?)', types) }

  def self.admin
    Role.find ROLE_ADMIN
  end
end
