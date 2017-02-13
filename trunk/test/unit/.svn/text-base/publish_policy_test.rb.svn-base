require 'test_helper'

class PublishPolicyTest < ActiveSupport::TestCase

  test "test create ad show control" do
    publish_policy = publish_policies :pp_ad_icon1
    ad_show_control = publish_policy.create_show_control
    ad = advertisements(:ad_icon_1)
    assert_equal ad, ad_show_control.advertisement
    assert_equal publish_policy, ad_show_control.publish_policy
    assert_equal campaigns(:campaign1), ad_show_control.campaign
    assert_equal parties(:ad_owner), ad_show_control.party
    assert_equal publish_policy.bid_price / publish_policy.pay_method.unit, ad_show_control.unit_price
    assert_equal publish_policy.start_from, ad_show_control.begin
    assert_nil ad_show_control.end
    assert_equal ad.ad_format, ad_show_control.ad_format
    assert_nil ad_show_control.content_categories
    assert_nil ad_show_control.ad_containers
  end

  test "create ad show control, specify ad containers" do
    publish_policy = publish_policies :pp_ad_icon1
    app1 = ad_containers(:app1)
    publish_policy.ad_containers << app1
    ad_show_control = publish_policy.create_show_control
    assert_equal "'#{app1.id}'", ad_show_control.ad_containers
  end

  test "create ad show control, specify content category" do
    publish_policy = publish_policies :pp_ad_icon1
    movie = content_categories :movie
    music = content_categories :music
    publish_policy.content_categories << movie
    publish_policy.content_categories << music
    show_control = publish_policy.create_show_control
    cat_ids = show_control.content_categories.split "'"
    cat_ids.delete_if { |id| id.strip.empty? }
    puts cat_ids
    assert_equal 2, cat_ids.size
    assert cat_ids.include? movie.id.to_s
    assert cat_ids.include? music.id.to_s
  end

  test "calculate_weight, only one publish_policy" do
    publish_policy = publish_policies :pp_ad_icon1
    assert_equal 1, publish_policy.calculate_weight
  end

  test "initial status after create" do
    publish_policy = create_publish_policy
    assert_equal PublishPolicy::STATUS_CREATING, publish_policy.status
  end

  test "execute" do
    publish_policy = create_publish_policy
    publish_policy.created!
    publish_policy.execute!
    assert_equal PublishPolicy::STATUS_RUNNING, publish_policy.status
    assert_not_nil publish_policy.ad_show_control
    assert publish_policy.running?
  end
  
  test "execute after end date" do
    publish_policy = create_publish_policy
    publish_policy.update_attribute :end_to, Date.today - 1
    publish_policy.created!
    assert publish_policy.stopped?
    publish_policy.execute!
    assert publish_policy.stopped?
    assert ! publish_policy.running?
    assert_nil publish_policy.ad_show_control
  end

  test "stop" do
    publish_policy = create_publish_policy
    publish_policy.created!
    publish_policy.execute!
    publish_policy.stop!
    assert_equal PublishPolicy::STATUS_STOPPED, publish_policy.status
    assert_nil publish_policy.ad_show_control
    assert publish_policy.stopped?
  end

  test "determine base price, no ad container specified" do
    ad_owner = Factory.create :party
    ad = Factory.create :advertisement, :party=>ad_owner
    cpm = Factory.create :cpm
    channel = Factory.create :channel
    publish_policy = Factory.create :publish_policy, :advertisement=>ad, :channel=>channel, :pay_method=>cpm
    adhub_operator = Party.adhub_operator
    Price.create! :pay_method=>cpm, :party=>adhub_operator, :channel=>channel, :base_price=>15
    assert_equal 15, publish_policy.determine_base_price
  end

  test "determine base price, specified ad container of ad_owner's agent who not defined price" do
    publisher = Factory.create :party
    ad_owner = Factory.create :party, :agent=>publisher
    ad = Factory.create :advertisement, :party=>ad_owner
    cpm = Factory.create :cpm
    channel = Factory.create :channel
    publish_policy = Factory.create :publish_policy, :advertisement=>ad, :channel=>channel, :pay_method=>cpm

    publish_policy.ad_containers << Factory.create(:ad_container, :party=>publisher)
    publish_policy.ad_containers << Factory.create(:ad_container, :party=>publisher)

    adhub_operator = Party.adhub_operator
    Price.create! :pay_method=>cpm, :party=>adhub_operator, :channel=>channel, :base_price=>15    
    assert_equal 15, publish_policy.determine_base_price
  end

  test "determine base price, specified ad container of ad_owner's agent who defined price" do
    publisher = Factory.create :party
    adhub_operator = Party.adhub_operator

    ad_owner = Factory.create :party, :agent=>publisher
    ad = Factory.create :advertisement, :party=>ad_owner
    cpm = Factory.create :cpm
    channel = Factory.create :channel
    publish_policy = Factory.create :publish_policy, :advertisement=>ad, :channel=>channel, :pay_method=>cpm

    publish_policy.ad_containers << Factory.create(:ad_container, :party=>publisher)
    publish_policy.ad_containers << Factory.create(:ad_container, :party=>publisher)

    Price.create! :pay_method=>cpm, :party=>publisher, :channel=>channel, :base_price=>20
    Price.create! :pay_method=>cpm, :party=>adhub_operator, :channel=>channel, :base_price=>15    
    assert_equal 20, publish_policy.determine_base_price
  end

  test "determine base price, specified ad containers of different publisher" do
    adhub_operator = Party.adhub_operator
    ad_owner = Factory.create :party, :agent=>adhub_operator
    ad = Factory.create :advertisement, :party=>ad_owner
    cpm = Factory.create :cpm
    channel = Factory.create :channel

    publish_policy = Factory.create :publish_policy, :advertisement=>ad, :channel=>channel, :pay_method=>cpm

    3.times do |i|
      publisher = Factory.create :party
      publish_policy.ad_containers << Factory.create(:ad_container, :party=>publisher)
      Price.create! :pay_method=>cpm, :party=>publisher, :channel=>channel, :base_price=>15 + i*5
    end

    Price.create! :pay_method=>cpm, :party=>adhub_operator, :channel=>channel, :base_price=>15    
    assert_equal 15, publish_policy.determine_base_price
  end

  test "price rank, only one publish policy" do
    publish_policy = Factory.create :publish_policy
    assert_equal 1, publish_policy.price_rank
  end

  test "price rank, two publish policies with same channel and pay method" do
    channel = Factory.create :channel
    cpm = Factory.create :cpm
    publish_policy1 = Factory.create :publish_policy, :channel=>channel, :bid_price=>20, :pay_method=>cpm
    publish_policy2 = Factory.create :publish_policy, :channel=>channel, :bid_price=>10, :pay_method=>cpm
    assert_equal 1, publish_policy1.price_rank
    assert_equal 0, publish_policy2.price_rank
  end

  test "price rank, three publish policies with same channel and pay method" do
    channel = Factory.create :channel
    cpm = Factory.create :cpm
    publish_policy1 = Factory.create :publish_policy, :channel=>channel, :bid_price=>20, :pay_method=>cpm
    publish_policy2 = Factory.create :publish_policy, :channel=>channel, :bid_price=>10, :pay_method=>cpm
    publish_policy3 = Factory.create :publish_policy, :channel=>channel, :bid_price=>15, :pay_method=>cpm
    assert_equal 1, publish_policy1.price_rank
    assert_equal 0, publish_policy2.price_rank
    assert_equal 0.5, publish_policy3.price_rank
  end

  test "price rank, two publish policies with different channel and same pay method" do
    cpm = Factory.create :cpm
    publish_policy1 = Factory.create :publish_policy, :bid_price=>20, :pay_method=>cpm
    publish_policy2 = Factory.create :publish_policy, :bid_price=>10, :pay_method=>cpm
    assert_equal 1, publish_policy1.price_rank
    assert_equal 1, publish_policy2.price_rank
  end 

  test "price rank, two publish policies with same channel and different pay method" do
    publish_policy1 = Factory.create :publish_policy, :bid_price=>20
    publish_policy2 = Factory.create :publish_policy, :bid_price=>10, :channel=>publish_policy1.channel
    assert_equal 1, publish_policy1.price_rank
    assert_equal 1, publish_policy2.price_rank
  end 

  def create_publish_policy
    advertisement = advertisements :ad_icon_1
    channel = channels :mobile_app
    campaign = campaigns :campaign1
    publish_policy = PublishPolicy.create :advertisement=>advertisement, :channel=>channel, :campaign=>campaign, 
      :start_from=>Date.today, :pay_method=>pay_methods(:cpm), :bid_price=>15, :name=>'test'
    publish_policy.call_to_action='url'    
    publish_policy.save!
    publish_policy
  end
end
