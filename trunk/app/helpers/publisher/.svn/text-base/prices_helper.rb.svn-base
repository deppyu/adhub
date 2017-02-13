# -*- coding: utf-8 -*-
module Publisher::PricesHelper
  def link_to_set_price(channel, pay_method)
    channel_id = channel ? channel.id : nil
    price = current_user.party.prices.where(:pay_method_id=>pay_method.id, :channel_id=>(channel_id) ).first
    id = "price_#{pay_method.id}_#{channel_id}"
    if price
      link_to price.base_price, edit_publisher_price_path(price, :format=>:html), :class=>'dialog_trigger', 
              'data-title'=>'设定价格', :id=>id
    else
      link_to '设定', new_publisher_price_path(:channel_id=>channel_id, :pay_method_id=>pay_method.id, :format=>:html), 
              :class=>'dialog_trigger', 'data-title'=>'设定价格', :id=>id
    end
  end
end
