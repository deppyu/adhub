# -*- coding: utf-8 -*-
class AdOwner::AdGroupsController < AdOwner::AdOwnerController
  before_filter :find_campaign, :except=>[:compare_price]
  before_filter :find_ad_group, :except=>[:index, :new, :create, :compare_price]

  def new
    @ad_group = @campaign.ad_groups.new
    @ad_group.start_from = @campaign.start_from
    @ad_group.end_to = @campaign.end_to
  
    logger.info CallToAction.actions
  end

  def create
    @ad_group = @campaign.ad_groups.build params[:ad_group]
    @ad_group.creating = true
    if @ad_group.save
      redirect_to edit_ad_owner_campaign_ad_group_url(@campaign, @ad_group, :step=>2, :format=>:html)
    else
      render :action=>:new
    end
  end

  def edit
    @content_categories = ContentCategory.where(:for_ad_container => true)
    render :action=>'edit_step_2' if '2' == params[:step] or @ad_group.creating
  end


  def update
    creating = @ad_group.creating
    @ad_group.creating = false
    logger.info "ad_group's call_to_action is #{@ad_group.call_to_action}"

    if @ad_group.update_attributes params[:ad_group]
      if params[:content_categories]
          ids = params[:content_categories].keys
          @ad_group.content_categories.clear
          ids.each do |element|
             content_category = ContentCategory.find element.to_i
             @ad_group.content_categories << content_category
          end                 
      end
      
      if creating
        redirect_to new_ad_owner_ad_group_advertisement_url(@ad_group, :format=>:html)
      else
        redirect_to ad_owner_campaign_ad_group_url(@campaign, @ad_group, :format=>:html)
      end
    else
      if '2' == params[:step]
        render :action=>:edit_step_2
      else
        render :action=>:edit
      end
    end
  end
  
  def destroy
    @ad_group = @campaign.ad_groups.find params[:id]
    if @ad_group.destroyable?
      @ad_group.destroy
      unless 'table' == params[:from]
        update_page_redirect_to ad_owner_campaign_url(@campaign)
        return
      end
    else
      alert '现在不能删除。'
    end
  end
  
 def revoke
    @ad_group.revoke!
    reshow_or_replace_tr
  end
  
  def stop
    @ad_group.stop!
    @message = '本广告组包含的所有广告都已停止投放。'
    reshow_or_replace_tr
  end
 
  def execute
    @ad_group.execute!
    @message = '本广告组包含的所有通过审核的广告已处于正常投放状态。'
    reshow_or_replace_tr
  end

  def submit
    @ad_group.submit!
    @message = '本广告组包含的所有编辑中的广告已提交审核。'
    reshow_or_replace_tr
  end

  def compare_price
    result = Advertisement.compare_price params[:pay_method_id].to_i, params[:price]
    logger.info "result = #{result}"
    case result
    when 1
      @message = '您的出价目前是最高的。'
    when 0
      @message = '您的出价目前是最低的。'
    else
      per = "#{( result * 1000.0 / 10.0).to_i}%"
      @message = t("compare_price_result.#{  (result * 100 / 33).to_i }", :per=>per)
    end
    render :text=>@message, :layout=>nil
  end

  private
  def find_campaign
    @campaign = current_user.campaigns.find params[:campaign_id]
  end

  def find_ad_group
    @ad_group = @campaign.ad_groups.find params[:id]
  end
  
  def reshow_or_replace_tr
    if 'table' == params[:from]
      render :action=>'replace_tr'
    else
      flash[:notice] = @message
      update_page_redirect_to ad_owner_campaign_ad_group_url(@campaign,@ad_group)
    end     
  end
end
