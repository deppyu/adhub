require 'test_helper'

class PartyTest < ActiveSupport::TestCase
  test "is valid agent" do
    agent = parties :agent
    assert agent.is_valid_agent?
  end

  test "is not valid publisher" do
    agent = parties :agent
    assert ! agent.is_valid_publisher?
  end

  test "is valid ad_owner" do
    agent = parties :ad_owner
    assert agent.is_valid_ad_owner?    
  end

  test "ad hub operator has all contracts" do
    operator = parties :adhub_op
    assert operator.is_valid_agent?
    assert operator.is_valid_publisher?
    assert operator.is_valid_ad_owner?
  end

  test "agent of adowner" do
    ad_owner_with_agent = parties :ad_owner_w_agent
    agent = parties(:agent)
    assert_equal agent, ad_owner_with_agent.agent
    assert_equal 1, agent.ad_owners.count
    assert agent.ad_owners.exists?(ad_owner_with_agent.id)
  end

  test "available roles for publisher" do
    publisher = parties(:publisher)
    available_roles = publisher.available_roles
    assert_equal 2, available_roles.size
    assert available_roles.include?(roles(:publisher))
    assert available_roles.include?(roles(:admin))
  end

  test "available roles for ad hub operator" do
    adhub_operator = parties :adhub_op
    assert_equal Role.count, adhub_operator.available_roles.size
  end

  test "test create account automatically" do
    party = Party.create! :name=>'test', :party_type=>Party::PARTY_TYPE_COMPANY, :address=>'a', :phone_number=>'123', 
      :post_code=>'111111'
    assert_not_nil party.account
  end
end
