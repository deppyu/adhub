require 'security_manager'

Fusion::Security::RoleRepository.config do |repository|
  repository.add_role :admin do |role|
    role.add_privilege [:modify_party, :manage_employee], 
      :condition=>Proc.new { |privilege, user, object|
      object and object == user.party
    }
  end

  repository.add_role :publisher do |role|
    role.add_privilege [:manage_containers, :manage_black_list, :set_price, :claim_cash]
  end

  repository.add_role :ad_owner do |role|
    role.add_privilege [:manage_campaign, :publish_ad, :manage_ad, :manage_budget],
    :condition=>Proc.new { |privilege, user, object| 
      object and object == user.party
    }
  end

  repository.add_role :agent do |role|
    role.add_privilege [:query_customer, :new_party]
    role.add_privilege [:manage_campaign, :publish_ad, :manage_ad, :manage_budget, :modify_party],
    :condition=>Proc.new { |privilege, user, object|
      object and object.respond_to?(:agent) and object.agent == user.party
    }
  end

  repository.add_role :sales do |role|
    role.add_privilege [:manage_campaign, :publish_ad, :manage_ad, :manage_budget], 
    :condition=>Proc.new { |privilege, user, object| 
      object and object.respond_to?(:sales) and object.sales == user 
    }
  end

  repository.add_role :member do |role|
    role.add_privilege :new_party, :condition=>Proc.new { |priv, user, object| user.party.nil? }
  end
end
