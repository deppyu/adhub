# encoding: UTF-8
namespace :init do

  task  :init_data => :environment do
    Member.transaction do 
      mobile_app = Channel.create! :name=>'移动应用', :ad_container_name=>'移动应用广告位'    

      operator = Party.create! :name=>'AdHub平台运营商', :adhub_operator=>true, :party_type=>Party::PARTY_TYPE_COMPANY, 
      :address=>"上海市浦东新区新金桥路28号", :post_code=>"201206", :phone_number=>"86(21)5032 8828"

      admin = Member.create! :email=>'admin@adhub.com', :password=>'admin', :is_admin=>true, :status=>Member::STATUS_ACTIVE,
      :party=>operator, :real_name=>'系统管理员'

        cpm = PayMethod.create! :name=>'CPM', :note=>'按千次展示收费。', :unit=>1000, 
      :pay_on=>PayMethod::PAY_ON_SHOW, :effect_string=>'显示数'
      cpc = PayMethod.create! :name=>'CPC', :note=>'按点击收费。', :unit=>1, 
      :pay_on=>PayMethod::PAY_ON_CLICK, :effect_string=>'点击数'
      
      Price.create! :pay_method=>cpm, :party=>operator, :channel=>mobile_app, :base_price=>(15.0/1000.0)
      Price.create! :pay_method=>cpc, :party=>operator, :channel=>mobile_app, :base_price=>(20.0)
      Price.create! :pay_method=>cpm, :party=>operator, :base_price=>(10.0/1000.0)
      Price.create! :pay_method=>cpc, :party=>operator, :base_price=>(15.0)

      SystemParameter.create :name=>'publisher_share_rate', :value_type=>SystemParameter::FLOAT_PARAM, :value=>0.85
      SystemParameter.create :name=>'agent_share_rate', :value_type=>SystemParameter::FLOAT_PARAM, :value=>0.05
    end
  end

  task :create_roles => :environment do
    Role.create! :code=>'admin', :name=>'管理员', :note=>'设置业务伙伴信息，管理员工及员工账号。'
    Role.create! :code=>'publisher', :name=>'发行业务管理', :required_contract_type=>Contract::BUSINESS_TYPE_PUBLISHER, 
      :note=>'管理广告发行业务，包括广告容器管理、价格管理、银行账户管理和提现申请。'
    Role.create! :code=>'ad_owner', :name=>'广告业务管理', :required_contract_type=>Contract::BUSINESS_TYPE_AD_OWNER,
      :note=>'广告业务管理，管理广告内容及广告发布、管理广告活动和预算分配。'
    Role.create! :code=>'agent', :name=>'广告代理业务管理', :required_contract_type=>Contract::BUSINESS_TYPE_AGENT,
      :note=>'广告代理业务管理，管理所代理广告客户。替广告客户管理广告业务。'
    Role.create! :code=>'sales', :name=>'广告业务员', :required_contract_type=>Contract::BUSINESS_TYPE_AGENT,
      :note=>'替自己负责的广告客户管理广告和广告发布业务。'

    Member.first.roles << Role.find_by_code(:admin)
  end
end
