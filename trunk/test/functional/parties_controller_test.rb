require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  setup :create_agent

  test "privilege, party admin edit party" do
    publisher = members :publisher
    logged_in publisher
    get :edit, :id=>publisher.party, :format=>:html
    assert_response :success
  end

  test "privilege, can't edit other party" do
    logged_in members(:publisher)
    get :edit, :id=>parties(:agent), :format=>:html
    assert_redirected_to main_url
  end

  test "agent can edit customer" do
    logged_in members(:agent)
    get :edit, :id=>parties(:ad_owner_w_agent), :format=>:html
    assert_response :success
  end

  test "agent can not edit non-customer" do
    logged_in members(:agent)
    get :edit, :id=>parties(:ad_owner), :format=>:html
    assert_redirected_to main_url
  end

  test "agent can list customers" do
    logged_in members(:agent)
    get :index, :format=>:html
    assert_response :success
  end

  test "non-agent can not list customers" do
    logged_in members(:ad_owner)
    get :index, :format=>:html
    assert_redirected_to main_url    
  end
  
  test "new user can create party" do
    member = Member.create! :email=>'test@test.com', :password=>'password', :status=>Member::STATUS_ACTIVE, :real_name=>'test'
    logged_in member
    get :new, :format=>:html
    assert_response :success
  end

  test "agent can create party" do
    logged_in members(:agent)
    get :new, :format=>:html
    assert_response :success
  end

  test "non-agent can not create more than one party" do
    logged_in members(:publisher)
    get :new, :format=>:html
    assert_redirected_to main_url
  end

  test "non-agent, after create party, creater is admin of the party" do
    member = Member.create! :email=>'test@test.com', :password=>'password', :status=>Member::STATUS_ACTIVE, :real_name=>'test'
    logged_in member
    post :create, :party=>{:party_type=>Party::PARTY_TYPE_PERSON, :name=>'test', :address=>'add', :phone_number=>'123', 
       :post_code=>'123456' }
    assert_redirected_to main_url
    new_party = assigns :party
    member.reload
    assert_equal new_party, member.party
    assert member.role_names.include?(:admin)
    assert new_party.agent.nil?
  end

  test "set customer's agent when agent create party" do
    agent = members :agent
    logged_in agent
    post :create, :party=>{:party_type=>Party::PARTY_TYPE_PERSON, :name=>'test', :address=>'add', :phone_number=>'123', 
       :post_code=>'123456' }, 
       :contract=>{:start_from=>'2012-01-01', :expired_at=>Date.today.next_year.to_s, :contact_person=>'abc', :mobile_phone=>'123' }
    assert_redirected_to parties_url(:format=>:html)
    new_party = assigns :party
    assert agent, new_party.agent
  end

  test "index, agent, no archived" do
    logged_in @member1
    get :index, :format=>:html
    assert_response :success
    assert_equal 1, assigns(:parties).count
    assert_equal "ad_party1", assigns(:parties).first.name
  end

  test "index, agent, archived" do
    logged_in @member1
    get :index, :archived=>"1", :format=>:html
    assert_response :success
    assert_equal 2, assigns(:parties).count
    assert_equal "ad_party2", assigns(:parties).second.name
  end

  test "archived, agent, contract all expired" do
    logged_in @member1
    #expired @agent1_party1 contract
    @agent1_party1.contracts.collect { |c| c.update_attributes :expiration_processed => 1 }
    @agent1_party1.reload

    post :archived, :id=>@agent1_party1.id, :format=>:js
    assert_response :success
    assert_equal @agent1_party1, assigns(:party)
    @agent1_party1.reload
    assert_equal true, @agent1_party1.archived
  end

  test "archived, agent, contract has unexpired" do
    logged_in @member1
    post :archived, :id=>@agent1_party1.id, :format=>:js
    assert_response :success
    @agent1_party1.reload
    assert_equal false, @agent1_party1.archived
  end
end
