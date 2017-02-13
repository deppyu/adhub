#-*-coding:utf-8 -*-
require 'dynamic_query'
require 'date'
class AdOwner::PublishPoliciesController < AdOwner::AdOwnerController
  include Imon::DynamicQuery
  before_filter :find_advertisement
  layout "default",:except=>[:search]
  
  def new
    @publish_policy= @advertisement.publish_policies.new
    @publish_policy.start_from = Time.now.strftime("%Y-%m-%d")
    @campaigns = Campaign.find_by_sql("select * from campaigns where end_to >= sysdate()")
    @channels = Channel.find_by_sql("select * from channels")
    @pay_methods = PayMethod.find_by_sql("select * from pay_methods")
  end
  
  def show
    @publish_policy = PublishPolicy.find params[:id]
  end
  
  def create
    start_from = params[:publish_policy][:start_from].to_date if params[:publish_policy][:start_from]
    end_to = params[:publish_policy][:end_to].to_date if params[:publish_policy][:end_to]
    @publish_policy = PublishPolicy.where(:name=>params[:publish_policy][:name],:campaign_id=>params[:publish_policy][:campaign_id].to_i,:channel_id=>params[:publish_policy][:channel_id].to_i,
                                          :start_from=>start_from,:end_to=>end_to,:pay_method_id=>params[:publish_policy][:pay_method_id].to_i,
                                          :daily_budget=>params[:publish_policy][:daily_budget].to_i,:call_to_action=>params[:publish_policy][:call_to_action]).first
    if @publish_policy
      redirect_to step_2_ad_owner_advertisement_publish_policy_path(@advertisement,@publish_policy,:format=>:html)
    else
      @publish_policy = @advertisement.publish_policies.build params[:publish_policy]
      @publish_policy.step = 2    
      if @publish_policy.save 
        redirect_to step_2_ad_owner_advertisement_publish_policy_path(@advertisement,@publish_policy,:format=>:html)
      else
        flash.now[:notice] = '发布不成功！'
        @campaigns = Campaign.find_by_sql("select * from campaigns where end_to >= sysdate()")
        @channels = Channel.find_by_sql("select * from channels")
        @pay_methods = PayMethod.find_by_sql("select * from pay_methods")
        render :action=>:new
      end
    end  
  end
  
  def step_2   
    @publish_policy = PublishPolicy.find params[:id]  
    @ad_containers_ex = @publish_policy.ad_containers.paginate :order=>"name",:page=>params[:page],:per_page=>12
  end
  
  def judge_successful_step_2
    @publish_policy = PublishPolicy.find params[:id]
    if @publish_policy.ad_containers.size > 0
       redirect_to step_3_ad_owner_advertisement_publish_policy_path(@advertisement,@publish_policy,:format=>:html)
    else
       ad_containers = @publish_policy.channel.ad_containers
       if ad_containers
           ad_containers.each do |ele|
                @publish_policy.ad_containers << ele
           end
       end
       redirect_to select_content_categories_ad_owner_advertisement_publish_policy_path(@advertisement,@publish_policy,:format=>:html)    
    end  
  end
  
  def select_content_categories
      @publish_policy = PublishPolicy.find params[:id]
      @content_categories = ContentCategory.find :all
  end
  
  def save_content_categories
      @publish_policy = PublishPolicy.find params[:id]
      if params[:content_categories]
         params[:content_categories].keys.each do |element|
            content_category = ContentCategory.find element.to_i
            @publish_policy.content_categories.concat content_category
         end
         redirect_to step_3_ad_owner_advertisement_publish_policy_path(@advertisement,@publish_policy,:format=>:html)
      else
         redirect_to step_3_ad_owner_advertisement_publish_policy_path(@advertisement,@publish_policy,:format=>:html)  
      end
  end
  
  def step_3   
     @publish_policy = PublishPolicy.find params[:id]
  end
  
  def save_step_3
    @publish_policy = PublishPolicy.find params[:id]
    if params[:publish_policy][:bid_price].to_f < @publish_policy.determine_base_price
       flash[:notice] = "您的出价不符要求！"
       render :action =>:step_3
    else
       unless @publish_policy.update_attribute (:bid_price,params[:publish_policy][:bid_price].to_f)
            flash[:notice] = '出价设置不成功！'
            render :nothing=>true
       else
            @publish_policy.update_attributes (:step=>3,:status=>PublishPolicy::STATUS_CREATED)
            flash[:notice] = '出价设置成功！'
            redirect_to  ad_owner_advertisement_path(@advertisement,:format=>:html)  
       end
     end
  end
  
  def decrease_ad_container
      @publish_policy = PublishPolicy.find params[:id]
      @ad_container = AdContainer.find params[:ad_container_id]
      if @ad_container
         unless @publish_policy.ad_containers.delete @ad_container
                alert '容器移除不成功！'
                render :nothing=>true
         else
                # @publish_policy.channel.ad_containers << @ad_container
                render :update do |page|
                  page.remove element_id(@ad_container)
                  page.insert_html :bottom,'ad_containers_list',:partial=>'ad',:object=>@ad_container
                end
         end
         
      else
         alert "该容器不存在"
      end
  end
  
  def increase_ad_container
      @publish_policy = PublishPolicy.find params[:id]
      @ad_container = AdContainer.find params[:ad_container_id]
      if @ad_container
         unless @publish_policy.ad_containers<< @ad_container
                alert '容器设置不成功！'
                render :nothing =>true
         else
               # @publish_policy.channel.ad_containers.delete @ad_container   
                render :update do |page|
                   page.remove element_id(@ad_container)
                   page.insert_html :bottom,'ad_containers_ex_list',:partial=>'ad_ex',:object=>@ad_container
                   
                end
         end
      else
         alert "该容器不存在"
      end
  end
  
  def stop
    @publish_policy = PublishPolicy.find params[:id]
    @publish_policy.stop!
    render :update do |page|
       page.replace element_id(@publish_policy), :partial=>'/ad_owner/advertisements/pp', :object=>@publish_policy
       page.replace element_id(@publish_policy), :partial=>'/ad_owner/campaigns/pp', :object=>@publish_policy
    end    
  end
  
  def execute
    @publish_policy = PublishPolicy.find params[:id]
    unless @publish_policy.execute!
       alert '执行不成功！'
    else
       render :update do |page|
         page.replace element_id(@publish_policy), :partial=>'/ad_owner/advertisements/pp', :object=>@publish_policy
         page.replace element_id(@publish_policy), :partial=>'/ad_owner/campaigns/pp', :object=>@publish_policy
       end
    end  
  end
  
  def notice_to_price
      @publish_policy = PublishPolicy.find params[:id]
      @publish_policy.bid_price = params[:b_price].to_f
      rate = @publish_policy.price_rank
      if @publish_policy
         case rate
          when 1 then render :json=>{:result=>'您的出价目前是最高的'}
          when 0 then render :json=>{:result=>'您的出价目前是最低的，请注意'}
          else render :json=>{:result=>"您的出价目前超过了#{rate*100}%出价"}
          end   
      end
  end
  
  def search
    @publish_policy = PublishPolicy.find params[:id]
    @ad_containers_ex = @publish_policy.ad_containers
    params.delete 'id'
    exps = expressions_from_params params, AdContainer
    @ad_containers = @publish_policy.channel.ad_containers.paginate :all,:conditions=>self.and(exps).conditions,:order=>'name',:page=>params[:page],:per_page=>12
    @ad_containers.delete_if{|e|@ad_containers_ex.include?e}   
  end
  
  protected
  def expression_for_name(name)
    self.like(:name,name)
  end
  
  private
  def find_advertisement
    @advertisement = Advertisement.find params[:advertisement_id] if params[:advertisement_id]
  end
end
