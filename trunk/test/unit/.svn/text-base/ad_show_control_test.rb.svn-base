require 'test_helper'

class AdShowControlTest < ActiveSupport::TestCase
  def setup
    @advertisement = advertisements(:ad_icon_1)
    @publish_policy = publish_policies :pp_ad_icon1
    assert_equal 1, @publish_policy.channel_id
    @ad_show_control = @publish_policy.create_show_control
    @ad_container = ad_containers(:app1)
  end

  test "check daily budget, no budget used" do
    assert @ad_show_control.check_daily_budget
  end

  test "check daily budget, ad_grop's budget used" do
    @publish_policy.update_attribute :daily_budget, 0.015
    AdRequest.create! :publisher=>@ad_container.party, :ad_container=>@ad_container, 
      :advertisement=>@advertisement, :publish_policy=>@publish_policy, :campaign=>@publish_policy.campaign, 
    :ad_owner=>@advertisement.party, :unit_price=>0.015, :pay_method=>pay_methods(:cpm)
    assert ! @ad_show_control.check_daily_budget
  end

  test "check daily budget, with old request" do
    @publish_policy.update_attribute :daily_budget, @publish_policy.bid_price
    AdRequest.create! :publisher=>@ad_container.party, :ad_container=>@ad_container, 
      :advertisement=>@advertisement, :publish_policy=>@publish_policy, :campaign=>@publish_policy.campaign, 
    :ad_owner=>@advertisement.party, :unit_price=>@publish_policy.bid_price, :pay_method=>pay_methods(:cpm), :request_date=>Date.today - 1
    assert @ad_show_control.check_daily_budget    
  end

  test "check daily budget, publish policy no daily budget" do
    @publish_policy.update_attribute :daily_budget, nil
    AdRequest.create! :publisher=>@ad_container.party, :ad_container=>@ad_container, 
      :advertisement=>@advertisement, :publish_policy=>@publish_policy, :campaign=>@publish_policy.campaign, 
    :ad_owner=>@advertisement.party, :unit_price=>0.015, :pay_method=>pay_methods(:cpm)
    assert @ad_show_control.check_daily_budget    
  end

  test "check daily budget, no campain daily budget" do
    @publish_policy.campaign.update_attribute :daily_budget, @ad_show_control.unit_price
    AdRequest.create! :publisher=>@ad_container.party, :ad_container=>@ad_container, 
      :advertisement=>@advertisement, :publish_policy=>@publish_policy, :campaign=>@publish_policy.campaign, 
    :ad_owner=>@advertisement.party, :unit_price=>@ad_show_control.unit_price, :pay_method=>pay_methods(:cpm)
    assert @ad_show_control.check_daily_budget
  end
end
