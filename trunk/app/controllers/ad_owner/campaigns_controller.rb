# -*- coding: utf-8 -*-
class AdOwner::CampaignsController < AdOwner::AdOwnerController
  before_filter :find_campaign, :except=>[:index, :new, :create, :budgets]

  def index
    @campaigns = Campaign.paginate :all, :conditions=>['party_id = ?', catch_ad_owner.id], 
    :order=>'start_from', :page=>params[:page], :per_page=>20
    logger.info "++++++++++++++++++++++++++++++++++++++++++++#{catch_ad_owner.id}"
  end

  def show
    @publish_policies = @campaign.publish_policies.paginate :order=>'name',:page=>params[:page],:per_page=>10   
  end
  
  def budget
    
  end

  def set_budget
    begin
    @campaign.transaction do
      @campaign.update_attributes! params[:campaign]
      params[:publish_policies].each_pair { |policy_id, attrs| 
        attrs.delete('_effect')
        @campaign.publish_policies.find(policy_id).update_attributes!(attrs)
      }      
      redirect_to ad_owner_campaign_path(@campaign, :format=>:html)
    end
    rescue ActiveRecord::RecordInvalid
      render :action=>:budget
    end
  end



  def new
    @campaign = catch_ad_owner.campaigns.new
  end
  
  def edit
    
  end
  
  def update
    unless @campaign.update_attributes params[:campaign]
      render :action=>:edit
    else
      redirect_to :action=>:show
    end
  end

  def create
    @campaign = catch_ad_owner.campaigns.build params[:campaign]
    if @campaign.save
      flash[:notice] ='新建成功！'
      redirect_to ad_owner_campaigns_url(:format=>:html)
    else
      render :action=>:new
    end
  end
  
  def destroy
    if @campaign.destroyable?
      @campaign.destroy
      if 'table' == params[:from]
        render :update do |page|
          page.remove element_id @campaign
        end
      else
        update_page_redirect_to ad_owner_campaigns_url(:format=>:html)
      end
    else
      alert '现在不能删除此广告活动。'
    end
  end

  def execute
    @campaign.execute!
    @message = '活动中的所有通过审核的广告都已经可以正常显示了。'
    reshow_or_replace_tr
  end

  def stop
    @campaign.stop!
    @message = '活动中的所有广告都已经停止投放了。'
    reshow_or_replace_tr
  end

  def submit
    @campaign.submit!
    @message = '活动中的所有编辑中的广告都已经提交审核了。'
    reshow_or_replace_tr    
  end

  def budgets
    @campaigns = catch_ad_owner.campaigns.paginate :page=>params[:page], :per_page=>20
  end

  private
  def find_campaign
    @campaign = catch_ad_owner.campaigns.find params[:id]
  end

  def reshow_or_replace_tr
    if 'table' == params[:from]
      render :action=>'replace_tr'
    else
      flash[:notice] = @message
      update_page_redirect_to ad_owner_campaign_url(@campaign, :format=>:html)
    end     
  end

end
