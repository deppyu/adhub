require 'test_helper'

class Admin::ContractsControllerTest < ActionController::TestCase

  test "set agent of party to adhub_operator when create an ad owner contract" do
    member = Factory.create :admin
    assert_not_nil member.party
    party = Factory.create :party
    logged_in(member)
    contract_param = Factory.attributes_for :contract, :business_type=>Contract::BUSINESS_TYPE_AD_OWNER
    post :create, :contract=>contract_param, :party_id=>party.id
    created_contract = assigns[:contract]
    assert_equal Contract::BUSINESS_TYPE_AD_OWNER, created_contract.business_type
    assert_redirected_to admin_party_path(created_contract.party, :format=>:html)
    assert_equal party, created_contract.party
    party.reload
    assert_equal member.party, created_contract.party.agent 
  end

  test "default value when new party" do
    member = Factory.create :admin
    party = Factory.create :party
    assert_not_nil party.id
    logged_in member
    get :new, :party_id=>party.id, :business_type=>Contract::BUSINESS_TYPE_PUBLISHER
    assert_template :new
    contract = assigns :contract
    assert_equal Contract::BUSINESS_TYPE_PUBLISHER, contract.business_type
    assert_equal Date.today, contract.start_from
    assert_equal Date.today.next_year, contract.expired_at
  end
end

