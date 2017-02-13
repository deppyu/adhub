ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  self.use_transactional_fixtures = false
  
# Add more helper methods to be used by all tests here...

  def json_response
       ActiveSupport::JSON.decode @response.body
  end

  def init_data
    #create channel
    @channel1 = Factory(:channel, :name=>"channel1")
    @channel2 = Factory(:channel, :name=>"channel2")
  end

  def create_agent
    @agent1 = Factory(:party)
    @agent1_contract1 = Factory(:contract, :party=>@agent1, :business_type=>Contract::BUSINESS_TYPE_AGENT)
    @member1 = Factory(:member, :party=>@agent1)
    @member1.roles <<  Role.find_by_code(:admin)
    @member1.roles <<  Role.find_by_code(:agent)
    #ad party
    @agent1_party1 = Factory(:party, :name=>"ad_party1", :agent_id=>@agent1.id)
    @contract1 = Factory(:contract, :party=>@agent1_party1, :business_type=>Contract::BUSINESS_TYPE_AD_OWNER)
    @agent1_party2 = Factory(:party, :name=>"ad_party2", :agent_id=>@agent1.id, :archived=>true)
    @contract2 = Factory(:contract, :party=>@agent1_party2, :business_type=>Contract::BUSINESS_TYPE_AD_OWNER)
  end # def create_agents

  def create_publisher
    @publisher1 = Factory(:party)
    @publisher1_contract1 = Factory(:contract, :party=>@publisher1, :business_type=>Contract::BUSINESS_TYPE_PUBLISHER)
    @publisher2 = Factory(:party)
    @publisher2_contract1 = Factory(:contract, :party=>@publisher2, :business_type=>Contract::BUSINESS_TYPE_PUBLISHER)
    @publisher1_member1 = Factory(:member, :party=>@publisher1)
    @publisher1_member1.roles << Role.find_by_code(:publisher)
    @publisher2_member1 = Factory(:member, :party=>@publisher2)
    @publisher2_member1.roles << Role.find_by_code(:publisher)

    # add ad_containers
    @publisher1_ad_container1 = Factory(:ad_container, :name=>"ad_container1", :party=>@publisher1, :channel=>@channel1)
    @publisher1_ad_container2 = Factory(:ad_container, :name=>"ad_container2", :party=>@publisher1, :channel=>@channel1)
    @publisher1_ad_container3 = Factory(:ad_container, :name=>"ad_container3", :party=>@publisher1, :channel=>@channel1)
    @publisher2_ad_container1 = Factory(:ad_container, :party=>@publisher2, :channel=>@channel1)
  end #def create_publisher

  def create_ad_owner
    @ad_owner1 = Factory(:party)
    @ad_owner2 = Factory(:party)
    @ad_owner2_contract1 = Factory(:contract, :party=>@ad_owner2, :business_type=>Contract::BUSINESS_TYPE_AD_OWNER)
    @ad_owner1_contract1 = Factory(:contract, :party=>@ad_owner1, :business_type=>Contract::BUSINESS_TYPE_AD_OWNER)
    @ad_owner1_member1 = Factory(:member, :party=>@ad_owner1)
    @ad_owner1_member1.roles << Role.find_by_code(:ad_owner)
    # create advertisement
    @ad_owner1_advertisement1 = Factory(:advertisement, :party=>@ad_owner1, :name=>"advertisement1")
    @ad_owner2_advertisement1 = Factory(:advertisement, :party=>@ad_owner2, :name=>"advertisement2")
  end

  def assert_difference_delta(expression, difference = 1, delta = 0.00001, message = nil, &block)
    expressions = Array.wrap expression

    exps = expressions.map { |e|
      e.respond_to?(:call) ? e : lambda { eval(e, block.binding) }
    }
    before = exps.map { |e| e.call }

    yield

    expressions.zip(exps).each_with_index do |(code, e), i|
      error  = "#{code.inspect} didn't change by #{difference}"
      error  = "#{message}.\n#{error}" if message
      assert_in_delta(before[i] + difference, e.call, delta, error)
    end
  end

end

class ActionController::TestCase
  def logged_in(user)
    session[:member_id] = user.id
  end
end

# TODO assert_difference_delta
