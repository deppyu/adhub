require 'test_helper'

class AdRequestsControllerTest < ActionController::TestCase

  def setup
    @app = Factory.create :application
    @ad_owner = Factory.create :party
    @publish_policy = Factory.create :created_publish_policy, :channel=>@app.channel, :pay_method=>Factory.create(:cpm)
    @publish_policy.execute!
    assert @publish_policy.pay_method
    Factory.create :publisher_contract, :party=>@app.party
    Factory.create :icon_resource, :advertisement=>@publish_policy.advertisement
    Factory.create :text_resource, :advertisement=>@publish_policy.advertisement
    Factory.create :text_resource, :advertisement=>@publish_policy.advertisement, :name=>'subtitle'
    @publish_policy.campaign.party.account.save! 1000
  end

  context 'Get advertisement from mobile phone' do
    should "return an advertisement when every thing is ok." do
      advertisement = @publish_policy.advertisement


      get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json

      assert_response :success
      puts response.body
      req_id = json_response['ad_request_id']
      ad_request = AdRequest.find req_id
      assert_equal @app, ad_request.ad_container
      assert_not_nil json_response['advertisement']
      ad = json_response['advertisement']
      assert_equal advertisement.id, ad['id'].to_i
      assert_equal advertisement.ad_format.name, ad['format']
      assert_not_nil json_response['call_to_action']
      assert_equal @publish_policy.call_to_action.name, json_response['call_to_action']['type']
      assert ad_request.fulfilled
      assert_equal @publish_policy.ad_show_control.unit_price, ad_request.unit_price      
    end

    should 'not return the advertisement whose ad owner has not enough balance' do
      @publish_policy.campaign.party.account.update_attribute :balance, 0

      get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json    
      assert_response :success
      assert json_response.empty?
    end

    context "given two ads" do
      setup {
        @publish_policy.campaign.party.account.save! 100

        @publish_policy2 = Factory.create :created_publish_policy, :channel=>@app.channel
        @publish_policy2.execute!
      }

      should "not return the advertisement whose daily budget used out." do
        @publish_policy2.update_attribute :daily_budget, 0
        get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
        puts response.body
        req_id = json_response['ad_request_id']
        ad_request = AdRequest.find req_id
        assert_equal @publish_policy.advertisement, ad_request.advertisement
      end
    end


    should "exclude repeated ad" do
      get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json, :last_ad=>@publish_policy.advertisement.id
      assert json_response.empty?
    end

  end

  # test "get ad, content category does not match" do
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.content_categories.clear
  #   @publish_policy.content_categories << content_categories(:movie)
  #   @publish_policy.call_to_action_params = ( {:url=>'http://www.foo.com'})
  #   @publish_policy.save!
  #   @publish_policy.stop!
  #   @publish_policy.execute!
  #   advertisement.party.account.save! 200

  #   @app.content_categories.clear
  #   @app.content_categories << content_categories(:music)
    
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert json_response.empty?
  # end

  # test "get ad, content category matched" do
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.content_categories.clear
  #   @publish_policy.content_categories << content_categories(:music)
  #   @publish_policy.call_to_action_params = ( {:url=>'http://www.foo.com'})
  #   @publish_policy.save!
  #   @publish_policy.stop!
  #   @publish_policy.execute!
  #   advertisement.party.account.save! 200

  #   @app.content_categories.clear
  #   @app.content_categories << content_categories(:music)
    
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   puts json_response
  #   assert !json_response.empty?
  # end

  # test "get ad, advertisement has content category, container not" do
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.content_categories.clear
  #   @publish_policy.content_categories << content_categories(:movie)
  #   @publish_policy.call_to_action_params = ( {:url=>'http://www.foo.com'})
  #   @publish_policy.save!
  #   @publish_policy.stop!
  #   @publish_policy.execute!
  #   advertisement.party.account.save! 200

  #   @app.content_categories.clear
    
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert json_response.empty?
  # end

  # test "get ad, container has content category, advertisement not" do
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.call_to_action_params = ( {:url=>'http://www.foo.com'})
  #   @publish_policy.save!
  #   advertisement.party.account.save! 200

  #   @app.content_categories.clear
  #   @app.content_categories << content_categories(:music)
    
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert !json_response.empty?
  # end


  # test "get ad, mobile phone, anti repeat request" do
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   @publish_policy.save
  #   advertisement.party.account.save! 100

  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert ! json_response.empty?
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert json_response.empty?
  # end

  # test "get ad, mobile phone, invalid publisher" do
  #   @app.party.contract_of(Contract::BUSINESS_TYPE_PUBLISHER).stop!
  #   @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   @publish_policy.save
  #   advertisement = advertisements(:ad_icon_1)
  #   advertisement.party.account.save! 100

  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert_response 400
  #   assert json_response.empty?
  # end

  # test "get ad, mobile phone, container invalid" do
  #   @app.update_attribute :status, AdContainer::STATUS_LOCKED
  #   advertisement = advertisements(:ad_icon_1)
  #   # advertisement.call_to_action_params = ({:url=>'http://www.foo.com'})

  #   # advertisement.save
  #   advertisement.party.account.save! 100

  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert json_response.empty?
  # end

  # test "get ad, mobile phone, channel not match" do
  #   @app.channel = channels(:subway)
  #   @app.save!
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   @publish_policy.save
  #   advertisement.party.account.save! 100

  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert_response :success
  #   assert json_response.empty?
  # end

  # test "get container, specify ad_container when publish, matched" do
  #   @publish_policy.ad_containers << ad_containers(:app1)
  #   @publish_policy.stop!
  #   @publish_policy.execute!

  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   @publish_policy.save
  #   advertisement.party.account.save! 100
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert_response :success
  #   assert ! json_response.empty?
  # end

  # test "get container, specify ad container when publish, not match" do
  #   @publish_policy.ad_containers << ad_containers(:app2)
  #   @publish_policy.stop!
  #   @publish_policy.execute!

  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   @publish_policy.save
  #   advertisement.party.account.save! 100
  #   get :index, :app=>@app.identity, :device=>'mobile_phone', :size=>'banner', :format=>:json
  #   assert_response :success
  #   puts "response.body = #{response.body}"
  #   assert json_response.empty?
  # end

  test "confirm shown" do
    # advertisement = advertisements(:ad_icon_1)
    # @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
    # @publish_policy.save
    # @publish_policy.stop!
    # @publish_policy.execute!

    # ad_owner = advertisement.party
    # ad_owner.account.save! 100
    # publisher = @app.party
    # publisher.account.update_attribute :balance, 0
    # ad_show_control = @publish_policy.ad_show_control

    # ad_request = AdRequest.create! :publisher=>publisher, :ad_container => @app, :unit_price=>ad_show_control.unit_price,
    # :advertisement=>advertisement, :pay_method=>@publish_policy.pay_method, :publish_policy=>@publish_policy, :ad_owner=>ad_owner
    
    ad_request = AdRequest.create! :publisher=>@app.party, :ad_container=>@app, :ip_address=>'127.0.0.1', :size_code=>'banner', :shown=>false
    ad_request.show_control = @publish_policy.ad_show_control
    ad_request.save!
    ad_owner = @publish_policy.advertisement.party
    ad_owner.account.save! 100
    publisher = @app.party
    
    assert ! ad_request.shown
    assert ad_request.pay_method.pay_on_show?

    assert_difference_delta 'publisher.account.balance', ad_request.unit_price * publisher.share_rate_for_other_customer, 0.0000001 do 
      assert_difference_delta 'ad_owner.account.balance', - ad_request.unit_price, 0.0000001 do

        post :shown, :id=>ad_request.id
        ad_request.reload
        assert ad_request.paid
        ad_owner.account.reload
        publisher.account.reload
      end
    end
    @publish_policy.campaign.reload
    assert_equal ad_request.unit_price, @publish_policy.campaign.used_budget
  end

  # test "repeat confirm shown" do
  #   advertisement = advertisements(:ad_icon_1)
  #   @publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   @publish_policy.save
  #   @publish_policy.stop!
  #   @publish_policy.execute!

  #   ad_owner = advertisement.party
  #   ad_owner.account.save! 100
  #   ad_show_control = @publish_policy.ad_show_control

  #   ad_request = AdRequest.create! :publisher=>@app.party, :ad_container => @app, :unit_price=>ad_show_control.unit_price,
  #   :advertisement=>advertisement, :pay_method=>@publish_policy.pay_method, :publish_policy=>@publish_policy, :ad_owner=>ad_owner
  #   post :shown, :id=>ad_request.id
  #   ad_owner.reload
  #   assert_equal 100 - ad_request.unit_price, ad_owner.account.balance
  #   @publish_policy.campaign.reload
  #   assert_equal ad_request.unit_price, @publish_policy.campaign.used_budget
  #   ad_request.reload
  #   post :shown, :id=>ad_request.id
  #   ad_owner.reload
  #   assert_equal 100 - ad_request.unit_price, ad_owner.account.balance
  #   @publish_policy.campaign.reload
  #   assert_equal ad_request.unit_price, @publish_policy.campaign.used_budget
  # end

  # test "confirm click" do
  #   advertisement = advertisements(:ad_icon_3)
  #   publish_policy = publish_policies :pp_ad_icon3
  #   publish_policy.call_to_action_params = ({:url=>'http://www.foo.com'})
  #   publish_policy.save
  #   publish_policy.execute!
    
  #   ad_owner = advertisement.party
  #   ad_owner.account.save! 100
  #   ad_show_control = publish_policy.ad_show_control
  #   ad_request = AdRequest.create! :publisher=>@app.party, :ad_container => @app, :unit_price=>ad_show_control.unit_price,
  #   :advertisement=>advertisement, :publish_policy=>publish_policy, :ad_owner=>ad_owner
  #   ad_request.pay_method= publish_policy.pay_method
  #   puts "ad_request.pay_method_id = #{ad_request.pay_method_id}"
  #   ad_request.save
  #   post :shown, :id=>ad_request.id
  #   post :clicked, :id=>ad_request.id
  #   ad_owner.account.reload
  #   assert_equal 100 - ad_request.unit_price, ad_owner.account.balance
  #   publish_policy.campaign.reload
  #   assert_equal ad_request.unit_price, publish_policy.campaign.used_budget    
  # end

end
