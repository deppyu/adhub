require 'test_helper'

class AdRequestTest < ActiveSupport::TestCase
  def setup
    @app = ad_containers(:app1)
    @advertisement = advertisements(:ad_icon_1)
    @publish_policy = publish_policies :pp_ad_icon1
  end

  context 'AdRequest with cpm policy' do
    setup {
      @ad_request = Factory.create :ad_request, :pay_method=>Factory.create(:cpm)
      @unit_price = @ad_request.unit_price
    }

    should 'pay on show' do
      assert ! @ad_request.paid
      assert_difference_delta '@ad_request.ad_owner.account.balance', -@unit_price do
        @ad_request.shown!
      end      
      assert @ad_request.paid
    end
    
    should 'no duplicate show' do
      @ad_request.shown!
      @ad_request.reload
      assert_difference '@ad_request.ad_owner.account.balance', 0 do
        @ad_request.shown!
      end
    end

    should "stop campaign after budget used" do
      @ad_request.campaign.update_attribute :budget, @unit_price
      @ad_request.campaign.reload
      @publish_policy = @ad_request.publish_policy
      @publish_policy.execute!
      assert @publish_policy.running?, 'publish_policy is running before shown!'
      @ad_request.shown!
      @publish_policy.reload
      assert @publish_policy.stopped?, 'publish_policy is stopped after all budget used'
    end

  end

  # test "shown" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.shown!
  #   ad_request.ad_owner.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account.balance
  #   ad_request.campaign.reload
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget
  # end

  # test "show, pay to publisher" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.publisher.account.save! 0
  #   ad_request.shown!
  #   publisher_rate = SystemParameter.find_or_create('publisher_share_rate', SystemParameter::FLOAT_PARAM).value
  #   ad_request.ad_container.reload
  #   assert_equal ad_request.unit_price * publisher_rate, ad_request.ad_container.income
  #   ad_request.publisher.reload
  #   assert_equal ad_request.unit_price * publisher_rate, ad_request.publisher.account_balance
  # end

  # test "no repeat shown" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.shown!
  #   ad_request.ad_owner.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account_balance
  #   ad_request.campaign.reload
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget
  #   ad_request.reload
  #   ad_request.shown!
  #   ad_request.ad_owner.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account_balance
  #   ad_request.campaign.reload
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget
  # end

  # test "stop campaign after budget used" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, ad_request.unit_price
  #   assert @publish_policy.running?
  #   ad_request.shown!
  #   @publish_policy.reload
  #   assert @publish_policy.stopped?
  # end

  # test "stop member's all ads after all balance used" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! ad_request.unit_price
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.shown!
  #   @advertisement.reload
  #   @publish_policy.reload
  #   ad_request.ad_owner.advertisements.each do |ad|
  #     assert ad.stoped? 
  #   end
  # end

  # test "test counter of advertisement" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   assert ad_request.pay_method.pay_on_show?
  #   ad_request.shown!
  #   @advertisement.reload
  #   assert_equal 1, @advertisement.impression_count
  #   @publish_policy.reload
  #   assert_equal ad_request.unit_price, @publish_policy.used_budget

  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.shown!
  #   @advertisement.reload
  #   assert_equal 2, @advertisement.impression_count
  #   @publish_policy.reload
  #   assert_equal 2 * ad_request.unit_price, @publish_policy.used_budget
  # end

  # test "test shown on cpc ad" do
  #   advertisement = advertisements(:ad_icon_3)

  #   ad_owner = advertisement.party
  #   publish_policy = PublishPolicy.create! :advertisement => advertisement, :campaign=>ad_owner.campaigns[0], 
  #     :channel_id=>channels(:mobile_app).id, 
  #     :start_from=>Date.today - 1, :end_to=>nil, :pay_method=>pay_methods(:cpc), :bid_price=>20,
  #     :daily_budget=>100, :name=>'test', :call_to_action=>'url'
  #   ad_request = create_ad_request @app, publish_policy
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   assert ! ad_request.pay_method.pay_on_show?
  #   ad_request.shown!
  #   assert_equal 100, ad_request.ad_owner.account.balance
  #   assert_equal 0, ad_request.campaign.used_budget
  # end

  # test "click! on cpc ad" do
  #   advertisement = advertisements(:ad_icon_3)
  #   ad_owner = advertisement.party
  #   publish_policy = PublishPolicy.create! :advertisement => advertisement, :campaign=>ad_owner.campaigns[0], 
  #     :channel_id=>channels(:mobile_app).id,
  #     :start_from=>Date.today - 1, :end_to=>nil, :pay_method=>pay_methods(:cpc), :bid_price=>20,
  #     :daily_budget=>100, :name=>'test', :call_to_action=>'url'

  #   ad_request = create_ad_request @app, publish_policy
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.publisher.account.update_attribute :balance, 0

  #   assert ! ad_request.pay_method.pay_on_show?
  #   ad_request.shown!
  #   ad_request.ad_owner.reload
  #   ad_request.campaign.reload
  #   assert_equal 100, ad_request.ad_owner.account_balance
  #   assert_equal 0, ad_request.campaign.used_budget    
  #   ad_request.publisher.reload
  #   assert_equal 0, ad_request.publisher.account_balance


  #   ad_request.clicked!
  #   ad_request.ad_owner.reload
  #   ad_request.campaign.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account_balance
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget    
  #   advertisement.reload
  #   assert_equal 1, advertisement.click_count
  #   assert ad_request.clicked

  #   publisher_rate = SystemParameter.find_or_create('publisher_share_rate', SystemParameter::FLOAT_PARAM).value
  #   ad_request.publisher.reload
  #   assert_equal ad_request.unit_price * publisher_rate, ad_request.publisher.account_balance

  # end

  # test "ingore repeat click" do
  #   advertisement = advertisements(:ad_icon_3)
  #   ad_owner = advertisement.party
  #   publish_policy = PublishPolicy.create! :advertisement => advertisement, :campaign=>ad_owner.campaigns[0], 
  #     :channel_id=>channels(:mobile_app).id,
  #     :start_from=>Date.today - 1, :end_to=>nil, :pay_method=>pay_methods(:cpc), :bid_price=>20,
  #     :daily_budget=>100, :name=>'test', :call_to_action=>'url'
  #   ad_request = create_ad_request @app, publish_policy
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   assert ! ad_request.pay_method.pay_on_show?
  #   ad_request.clicked!
  #   ad_request.ad_owner.reload
  #   ad_request.campaign.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account_balance
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget    
  #   advertisement.reload
  #   assert_equal 1, advertisement.click_count
  #   assert ad_request.clicked

  #   ad_request.clicked!
  #   ad_request.ad_owner.reload
  #   ad_request.campaign.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account_balance
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget    
  #   advertisement.reload
  #   assert_equal 1, advertisement.click_count
  #   assert ad_request.clicked   
  # end

  # test "auto-shown when clicked" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.clicked!
  #   ad_request.ad_owner.reload
  #   assert_equal 100 - ad_request.unit_price, ad_request.ad_owner.account.balance
  #   ad_request.campaign.reload
  #   assert_equal ad_request.unit_price, ad_request.campaign.used_budget    
  #   @advertisement.reload
  #   assert_equal 1, @advertisement.impression_count
  #   assert_equal 1, @advertisement.click_count
  # end

  # test "test after create, container counter" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   @app.reload
  #   assert_equal 1, @app.request_count
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   @app.reload
  #   assert_equal 2, @app.request_count
  # end

  # test "shown, container counter" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.shown!
  #   @app.reload
  #   assert_equal 1, @app.show_count
  #   @app.reload
  #   assert_equal 1, @app.show_count
  # end

  # test "clicked, container counter" do
  #   ad_request = create_ad_request(@app, @publish_policy)
  #   ad_request.ad_owner.account.save! 100
  #   ad_request.campaign.update_attribute :budget, 100
  #   ad_request.clicked!
  #   @app.reload
  #   assert_equal 1, @app.show_count
  #   assert_equal 1, @app.click_count
  # end

  context "Test settlement" do
    setup {
      @ad_request = Factory.create :ad_request
      @unit_price = @ad_request.unit_price
      @adhub_operator = Party.adhub_operator
    }

    should "withdraw unit_price from ad_owner's account" do
      assert_difference_delta '@ad_request.ad_owner.account.balance', -@unit_price do
        @ad_request.settlement
      end
    end

    should "pay unit_price * publisher_share_rate to publisher" do
      assert_difference_delta '@ad_request.publisher.account.balance', @unit_price * @ad_request.publisher_share_rate do
        @ad_request.settlement
      end
    end

    should "pay unit_price * (1 - publisher_share_rate) * agent_share_rate to agent" do
      @ad_request.agent = Factory.create :party
      assert_difference_delta "@ad_request.agent.account.balance", @unit_price * (1- @ad_request.publisher_share_rate) * @ad_request.agent_share_rate do
        @ad_request.settlement
      end
    end

    should 'pay unit_price * (1- publisher_share_rate) * (1 - agent_share_rate) to adhub_operator' do
      assert_difference_delta "@adhub_operator.account.balance", @unit_price * (1- @ad_request.publisher_share_rate) * (1- @ad_request.agent_share_rate) do
        @ad_request.settlement
        @adhub_operator.account.reload
      end
    end

  end

  private
  def create_ad_request(ad_container, publish_policy, size_code='icon_text')
    advertisement = publish_policy.advertisement
     AdRequest.create! :publisher=>ad_container.party, :ad_container=>ad_container, :advertisement => advertisement, 
    :publish_policy=>publish_policy, :campaign=>publish_policy.campaign, :ad_owner=>advertisement.party,
    :unit_price => publish_policy.bid_price, :pay_method=>publish_policy.pay_method, :size_code=>size_code,
    :ip_address => '127.0.0.1'
  end
end
