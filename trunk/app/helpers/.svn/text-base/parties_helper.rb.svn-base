# -*- coding: utf-8 -*-
module PartiesHelper
  def get_party_type(type)
    t "party.party_type.#{type}"
  end

  def party_type_select(form, method, options={})
    option_tags=[['公司', Party::PARTY_TYPE_COMPANY], ['个人', Party::PARTY_TYPE_PERSON]]
    form.select method, option_tags, options 
  end

  def party_type_select_tag(method, selected=nil, options={})
    option_tags=[['公司', Party::PARTY_TYPE_COMPANY], ['个人', Party::PARTY_TYPE_PERSON]]
    select_tag method, options_for_select(option_tags, selected), options
  end
  
  def choice_ad_maintained_by
    Party::ALL_AD_MAINTAINED_BY.collect{|t|[party_ad_maintained_by_fetch(t),t]}
  end
  
  def party_ad_maintained_by_fetch(ad_maintained_by)
    t "party.ad_maintained_by.#{ad_maintained_by}"
  end
end
