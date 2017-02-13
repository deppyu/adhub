# -*- coding: utf-8 -*-
class SystemParameter < ActiveRecord::Base
  INT_PARAM = 0
  FLOAT_PARAM = 1
  DATE_PARAM = 2
  STRING_PARAM = 3
  TIME_PARAM = 4
  BOOLEAN_PARAM = 5
  
  VALUE_FIELDS = ['int_value', 'float_value', 'date_value', 'string_value', 'time_value', 'boolean_value']

  # 发行商对自有客户的提成比例
  PUBLISHER_SHARE_RATE_FOR_OWNER_CUSTOMER = 'sr_owner_customer'
  
  # 发行商对其它客户(非自有客户)的提成比例
  PUBLISHER_SHARE_RATE_FOR_OTHER_CUSTOMER = 'sr_other_customer'

  # 代理商对于客户自行发布的广告的提成比例
  AGENT_SHARE_RATE = 'sr_agent'

  # 代理商对代行发布的广告的提成比例
  AGENT_SHARE_RATE_FOR_DELEGATE_ADV = 'sr_agent_delegate_ad'

  def self.find_or_create(name, value_type)
    param = self.find_by_name name
    unless param
      param = self.create! :name=>name, :value_type=>value_type
    end
    return param
  end

  def value
    self[VALUE_FIELDS[self.value_type]]
  end

  def value=(value)
    self[VALUE_FIELDS[self.value_type]] = value
  end
end
