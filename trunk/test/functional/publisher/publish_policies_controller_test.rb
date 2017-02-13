require 'test_helper'

class Publisher::PublishPoliciesControllerTest < ActionController::TestCase
  setup :init_data, :create_publisher, :create_ad_owner

  test "index, only search by name" do
    logged_in @publisher1_member1
    policy1 = Factory(:publish_policy, :name=>"policy1", :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1)
    policy2 = Factory(:publish_policy, :name=>"policy2", :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1)

    get :index, :name=>"2", :format=>:html
    assert_response :success
    assert_equal 1, assigns(:publish_policies).count
    assert_equal policy2, assigns(:publish_policies).first
  end # test index.. only ..by name

  test "index, only search by channel" do
    logged_in @publisher1_member1
    policy1 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1)
    policy2 = Factory(:publish_policy, :channel=>@channel2, :advertisement=>@ad_owner1_advertisement1)

    get :index, :channel_id=>@channel1.id.to_s, :format=>:html
    assert_response :success
    assert_equal 1, assigns(:publish_policies).count
    assert_equal policy1, assigns(:publish_policies).first
  end # test index...only.. by channel

  test "index, only search by advertisement'name" do
    logged_in @publisher1_member1
    advertisement1 = Factory(:advertisement, :party=>@ad_owner1, :name=>"iphone")
    advertisement2 = Factory(:advertisement, :party=>@ad_owner1, :name=>"ipad")
    policy1 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>advertisement1)
    policy2 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>advertisement2)

    get :index, :advertisement=>"pad", :format=>:html
    assert_response :success
    assert_equal 1, assigns(:publish_policies).count
    assert_equal policy2, assigns(:publish_policies).first
  end # test index.. only.. advertisement'name

  test "index, no params, end_to time less than today" do
    logged_in @publisher1_member1
    policy1 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1, :end_to=>Time.now.prev_month)
    policy2 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1, :end_to=>Time.now)

    get :index, :format=>:html
    assert_response :success
    assert_equal 1, assigns(:publish_policies).count
    assert_equal policy2, assigns(:publish_policies).first
  end # test index..no params.. less than today

  test "index, no params, publisher's ad_containers include policy's ad_container" do
    logged_in @publisher1_member1
    policy1 = Factory(:publish_policy, :channel=>@channel2, :advertisement=>@ad_owner1_advertisement1)
    policy1.ad_containers << @publisher1_ad_container1
    policy2 = Factory(:publish_policy, :channel=>@channel2, :advertisement=>@ad_owner1_advertisement1)

    get :index, :format=>:html
    assert_response :success
    assert_equal 1, assigns(:publish_policies).count
    assert_equal policy1, assigns(:publish_policies).first
  end # test index..publisher's ad_containers include policy's ad_container

  test "index, no params, publisher's ad_containers ex policy's ad_containers, but publisher ad_containers' channels include policy's channel" do
    logged_in @publisher1_member1
    policy1 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1)
    policy2 = Factory(:publish_policy, :channel=>@channel1, :advertisement=>@ad_owner1_advertisement1)

    get :index, :format=>:html
    assert_response :success
    assert_equal 2, assigns(:publish_policies).count
  end # test index ....but publisher ad_containers' channels include..channel
end # class
