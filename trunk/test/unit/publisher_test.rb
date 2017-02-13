require 'test_helper'

class PublisherTest < ActiveSupport::TestCase

  def setup
    @channel = channels :mobile_app
    @cpm = pay_methods :cpm
    @ad_owner = parties :ad_owner
  end

  test "find base price for operator" do
    operator = parties :adhub_op
    price = prices :op_mobile_app_cpm
    assert_equal price.base_price, operator.base_price(@channel, @cpm, @ad_owner)
  end

  test "find base price for publisher" do
    publisher = parties :publisher
    price = prices :op_mobile_app_cpm
    assert_equal price.base_price, publisher.base_price(@channel, @cpm, @ad_owner)
  end

  test "find base price for publisher, self's ad owner" do
    publisher = parties :publisher
    @ad_owner.agent = publisher
    Price.create! :party=>publisher, :channel=>@channel, :pay_method=>@cpm, :base_price=>0.01
    assert_equal 0.01, publisher.base_price(@channel, @cpm, @ad_owner)
  end

  test "find base price, self's ad owner, has not set price for self's ad owner" do
    publisher = parties :publisher
    @ad_owner.agent = publisher
    price = prices :op_mobile_app_cpm
    assert_equal price.base_price, publisher.base_price(@channel, @cpm, @ad_owner)
  end

  test "find base price for publisher, has set price for self's ad owner, not self's ad owner" do
    publisher = parties :publisher
    ad_owner = parties :ad_owner_w_agent
    price = prices :op_mobile_app_cpm
    Price.create! :party=>publisher, :channel=>@channel, :pay_method=>@cpm, :base_price=>0.01
    assert_equal price.base_price, publisher.base_price(@channel, @cpm, @ad_owner)
  end

  test "base price for publisher's own advertisement" do
    publisher = parties :publisher
    assert_equal 0, publisher.base_price(@channel, @cpm, publisher)
  end

  test "default price" do
    channel = Channel.create! :name=>'new channel', :ad_container_name=>'ad container'
    publisher = parties :publisher
    default_price = prices :default_cpm_price
    assert_equal default_price.base_price, publisher.base_price(channel, @cpm, parties(:ad_owner))
  end

  test "share rate for own customer" do
    contract = Factory.create :publisher_contract
    assert_equal contract.party.share_rate_for_own_customer, contract.share_rate_1
  end

  test "share rate for own customer, fallback to system default" do
    default_rate_param = SystemParameter.find_or_create SystemParameter::PUBLISHER_SHARE_RATE_FOR_OWNER_CUSTOMER, SystemParameter::FLOAT_PARAM
    default_rate_param.value= 0.8
    default_rate_param.save!
    
    contract = Factory.create :publisher_contract, :share_rate_1=>nil
    assert_equal 0.8, contract.party.share_rate_for_own_customer
  end

  test "share rate for owner customer, when no contract" do
    party = Factory.create :party
    
    assert_equal 0, party.share_rate_for_own_customer
  end
end
