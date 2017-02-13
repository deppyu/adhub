require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  def setup
    @advertisement = advertisements(:ad_icon_1)
    @advertisement.update_attribute :status, Advertisement::STATUS_APPROVED
    @mobile_app = channels :mobile_app
    @cpm = pay_methods :cpm
  end

  test "stop" do
    publish_policy = PublishPolicy.create! :advertisement=>@advertisement, :campaign=>campaigns(:campaign1), 
      :channel=>@mobile_app, :status=>PublishPolicy::STATUS_STOPPED, :start_from=>Date.today - 2, :bid_price=>0.015, :call_to_action=>'url',
      :name=>'test', :pay_method=>@cpm
    publish_policy.execute!
    assert publish_policy.ad_show_control
    @advertisement.stop!
    assert_equal Advertisement::STATUS_APPROVED, @advertisement.status
    assert @advertisement.stoped?
    assert @advertisement.ad_show_controls.empty?
    @advertisement.publish_policies.each { |pp| 
      assert pp.stopped?
    }
  end

  test "execute, one publish policy" do
    # publish_policy = @advertisement.publish_policies.create! :campaign=>campaigns(:campaign1), 
    #   :channel=>@mobile_app, :creating=>false, :start_from=>Date.today - 2, :bid_price=>0.015, :call_to_action=>'url',
    #   :name=>'test', :pay_method=>@cpm
    assert_equal 1, @advertisement.publish_policies.size
    publish_policy = publish_policies :pp_ad_icon1
    publish_policy.stop!
    @advertisement.update_attribute :status, Advertisement::STATUS_APPROVED
    @advertisement.execute!
    assert_equal 1, @advertisement.ad_show_controls.size
    assert_equal publish_policy, @advertisement.ad_show_controls[0].publish_policy
    assert @advertisement.running?
  end

  test "execute, two publish policies" do
    publish_policies(:pp_ad_icon1).stop!
    publish_policy = @advertisement.publish_policies.create! :campaign=>campaigns(:campaign1), 
      :channel=>@mobile_app, :status=>PublishPolicy::STATUS_STOPPED, :start_from=>Date.today - 2, :bid_price=>0.015, :call_to_action=>'url',
      :name=>'test', :pay_method=>@cpm
    assert_equal 2, @advertisement.publish_policies.size
    @advertisement.update_attribute :status, Advertisement::STATUS_APPROVED
    @advertisement.execute!
    assert_equal 2, @advertisement.ad_show_controls.size
    assert publish_policy.running?
  end

  test "execute, no publish policy" do
    ad = advertisements :ad_icon_2
    ad.update_attribute :status, Advertisement::STATUS_APPROVED
    assert ad.publish_policies.empty?
    ad.execute!
    assert_equal Advertisement::STATUS_APPROVED, ad.status
    assert ad.ad_show_controls.empty?
  end

  test "has effective publish" do
    assert @advertisement.has_effective_publish
  end

  test "no effective publish" do
    ad = advertisements :ad_icon_2
    assert ! ad.has_effective_publish
  end

  test "revoke when running" do
    publish_policy = publish_policies :pp_ad_icon1
    ad = publish_policy.advertisement
    publish_policy.stop!
    assert ad.stoped?
    publish_policy.execute!
    assert_equal 1, ad.publish_policies.size
    assert_equal publish_policy, ad.publish_policies[0]

    ad.publish_policies[0].reload
    puts "ad.stoped? #{ad.stoped?}"
    assert ! ad.stoped?
    assert ad.running?
    ad.revoke!
    assert_equal Advertisement::STATUS_EDITING, ad.status
    assert ad.stoped?
  end
end
