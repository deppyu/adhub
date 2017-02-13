# -*- coding: utf-8 -*-
module Agent
  def self.included(base)
    base.class_eval do 
      has_many :ad_owners, :class_name=>'Party', :foreign_key=>'agent_id'
    end
  end

  # 代理商的广告提成比例
  def agent_share_rate
    share_rate Contract::BUSINESS_TYPE_AGENT, :share_rate_1, SystemParameter::AGENT_SHARE_RATE
  end

end
