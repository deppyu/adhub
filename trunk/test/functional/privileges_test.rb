require 'test_helper'
require 'security_manager'

class PrivilegesTest < ActiveSupport::TestCase
  include Fusion::Security

  test "publisher has privilege manage_containers" do
    publisher = members :publisher
    assert_not_nil publisher.party
    assert publisher.party.is_valid_publisher?
    assert publisher.role_names.include?(:publisher)
    assert has_privilege(:manage_containers, publisher)
  end

  
  test "sales has privilege manage_campaign on his customer" do
    sales = members :sales
    puts "sales.role_names is #{sales.role_names}"
    assert sales.role_names.include?(:sales)
    customer = parties :ad_owner_w_agent
    assert_equal sales, customer.sales
    assert has_privilege(:manage_campaign, sales, customer)
  end

  test "sales has no privilge manage_campaign on party not his customer" do
    sales = members :sales
    ad_owner = parties(:ad_owner)
    assert ad_owner.sales != sales
    assert ! has_privilege(:manage_campaign, sales, ad_owner)
  end

  test "agent has privilege manage_campaign on his customer" do
    agent = members :agent
    customer = parties :ad_owner_w_agent
    assert_equal agent.party, customer.agent
    assert customer.sales != agent
    assert has_privilege(:manage_campaign, agent, customer)
  end

  test "agent has no privilege manage_campaign on party not cusomter" do
    agent = members :agent
    customer = parties :ad_owner
    assert agent.party != customer.agent
    assert customer.sales != agent
    assert ! has_privilege(:manage_campaign, agent, customer)    
  end

  test "ad_owner has privilege manage_campaign on himself" do
    ad_owner = members :ad_owner
    assert has_privilege(:manage_campaign, ad_owner, ad_owner.party)
  end

  test "a_owner has no privilege manage_campaign on other's " do
    ad_owner = members :ad_owner
    ad_owner2 = parties :ad_owner_w_agent
    assert ! has_privilege(:manage_campaign, ad_owner, ad_owner2)
  end

end
