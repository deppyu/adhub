FactoryGirl.define do
  # sequence :real_name do |n| 
  #   "member_#{n}" 
  # end

  factory :channel do 
    sequence(:name) { |n| "Channe_#{n}" }
    ad_container_name { "#{name}" }
  end

  factory :pay_method do
    unit 1
    sequence(:name) { |n| "pm_#{n}"}
    note 'pm note'
    effect_string 'pm effect' 
    pay_on PayMethod::PAY_ON_CLICK

    factory :cpm do
      unit 1000
      pay_on PayMethod::PAY_ON_SHOW
    end

    factory :cpc do
    end
  end

  factory :member do
    sequence(:real_name) { |n| "member_#{n} " }
    email { "#{real_name}@abc.com" }
    is_admin false
    status Member::STATUS_ACTIVE
    password 'password'
    association :party
    factory :admin do
      is_admin true
    end
  end

  factory :party do 
    party_type Party::PARTY_TYPE_COMPANY
    #association :agent, :factory=>:party
    adhub_operator false
    sequence(:name) { |n| "Party_#{n}" }
    address { "#{name}'s address" }
    phone_number '12345678'
    post_code '123456'
    archived false

    factory :adhub_operator do
      adhub_operator true
    end

    factory :ad_owner do
      association :agent, :factory=>:party
    end
  end

  factory :contract do
    start_from { Date.today }
    expired_at { Date.today.next_year }
    contact_person 'person'
    mobile_phone '123456'
    association :party

    factory :publisher_contract do
      business_type Contract::BUSINESS_TYPE_PUBLISHER
      share_rate_1 0.9
      share_rate_2 0.8
    end

    factory :agent_contract do
      business_type Contract::BUSINESS_TYPE_AGENT
      share_rate_1 0.1
      share_rate_2 0.05
    end

    factory :ad_owner_contract do
      business_type Contract::BUSINESS_TYPE_AD_OWNER
    end

  end

  factory :ad_container do
    association :party
    association :channel
    status AdContainer::STATUS_ACTIVE
    sequence(:name) { |n| "AdContainer_#{n}" }
    identity { UUID.new.generate }
    description 'desc'
    
    factory :application, :class=>Application do 
      url { "http://www.adhub.com/#{name}" }
      os_type Application::OS_ANDROID
    end
  end

  factory :publish_policy do
    association :campaign
    advertisement { Factory.create(:advertisement, :party=> campaign.party) }
    association :channel

    status PublishPolicy::STATUS_RUNNING
    start_from { Date.today }
    end_to { Date.today.next_month }
    association :pay_method 
    bid_price 10
    daily_budget 100
    sequence(:name) { |n| "PublishPolicy_#{n}" }
    
    factory :creating_publish_policy do
      status PublishPolicy::STATUS_CREATING
    end

    factory :created_publish_policy do
      status PublishPolicy::STATUS_CREATED
    end

  end

  factory :campaign do
    association :party
    start_from { Date.today }
    end_to { Date.today.next_month }
    budget 10000
    daily_budget 1000
    sequence(:name) { |n| "Campaign_#{n}" }
    description 'desc'
  end

  factory :advertisement do
    association :party
    status Advertisement::STATUS_APPROVED
    ad_format 'icon_text'
    sequence(:name) { |n| "Ad_#{n}" }
    content_url { "http://www.ad.com/#{name}" }
  end

  factory :ad_resource do 
    association :advertisement
    association :member
    
    factory :icon_resource do
      ad_format { AdFormat.of_name 'icon_text' }
      name 'icon'
      width 80
      height 80
      size_code :square
      file File.new(File.join(Rails.root, 'test', 'image', 'img_80_80.jpg'))
      file_content_type 'image/jpeg'
    end

    factory :text_resource do
      ad_format { AdFormat.of_name 'icon_text' }
      name 'title'
      text 'Text'
    end
  end

  factory :ad_request do
    association :ad_container
    publisher { ad_container.party }
    association :publish_policy
    advertisement { publish_policy.advertisement }
    ad_owner { advertisement.party }
    agent { ad_owner.agent }
    campaign { publish_policy.campaign }
    unit_price { publish_policy.unit_price }
    pay_method { publish_policy.pay_method }
    publisher_share_rate 0.8
    agent_share_rate 0.1
    request_date { Date.today }
    ip_address '127.0.0.1'
    size_code 'square'
    shown false
  end
end
