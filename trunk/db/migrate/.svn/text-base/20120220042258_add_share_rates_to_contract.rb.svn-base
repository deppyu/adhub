# -*- coding: utf-8 -*-
class AddShareRatesToContract < ActiveRecord::Migration
  def self.up
    # 对发行商合同，share_rate_1是针对自己的广告客户的提成比例，NULL或负数表示使用系统缺省设置。
    # 对代理商合同，:share_rate_1是代理商代为发布的广告的提成比例，NULL或负数表示使用系统缺省设置。
    add_column :contracts, :share_rate_1, :float 

    # 对发行商合同，share_rate_2是针对平台或其它代理商的广告客户的提成比例，NULL或负数表示使用系统缺省设置。
    # 对代理商合同，:share_rate_2是客户自行发布的广告的提成比例，NULL或负数表示使用系统缺省设置。
    add_column :contracts, :share_rate_2, :float     
  end

  def self.down
  end
end
