# -*- coding: utf-8 -*-
require 'dynamic_query'
class AdOwner::AdvertisementsController < AdOwner::AdOwnerController
  # before_filter :find_ad_group
  include Imon::DynamicQuery
  before_filter :find_advertisement, :except=>[:index, :new, :create]
  def index
    exps = expressions_from_params params, Advertisement
    @advertisements = catch_ad_owner.advertisements.paginate :conditions=>self.and(exps).conditions,:order=>'name',:page=>params[:page],:per_page=>10
    if @advertisements==nil
      logger.info "++++++++++++++++++it nil"
    end
  end

  def new
    @advertisement = catch_ad_owner.advertisements.new
  end

  def create
    @advertisement = catch_ad_owner.advertisements.build params[:advertisement]
    # @advertisement.call_to_action_params = params[:call_to_action_params]
    begin
      Advertisement.transaction do
        if @advertisement.save!
          resource_ids = params[:resource_ids].split(',').collect { |id| id.to_i}
          resource_ids.each do |resource_id|
            link_resource_to_advertisement resource_id, @advertisement
          end

          if params[:text_resource]
            params[:text_resource].each_pair do |resource_name, text|
              create_text_resource @advertisement, resource_name, text
            end
          end
        end
      end
      redirect_to ad_owner_advertisements_path(:format=>:html)

    rescue ActiveRecord::RecordInvalid => ex
    render :action=>:new
    end
  end

  def update
    begin
      @advertisement.attributes = params[:advertisement]
      @advertisement.call_to_action_params = params[:call_to_action_params]
      if @advertisement.save
        resource_ids = params[:resource_ids].split(',').collect { |id| id.to_i}
        remove_unused_non_text_resource resource_ids, @advertisement
        resource_ids.each do |resource_id|
          logger.info 'now link resource #{resource_id} to ad.'
          link_resource_to_advertisement resource_id, @advertisement
        end
        if params[:text_resource]
          params[:text_resource].each_pair do |resource_name, text|
            update_text_resource @advertisement, resource_name, text
          end
        end
      end
      redirect_to ad_owner_advertisement_url(@advertisement, :format=>:html)
    rescue ActiveRecord::RecordInvalid => ex
    render :action=>:edit
    end
  end

  def submit_approve
    if @advertisement.waiting_submit_approve?
    @advertisement.submit_approve!
    end
    reshow_or_replace_tr
  end

  def revoke
    @advertisement.revoke!
    reshow_or_replace_tr
  end

  def stop
    @advertisement.stop!
    reshow_or_replace_tr
  end

  def execute
    @advertisement.execute!
    reshow_or_replace_tr
  end

  def destroy
    if @advertisement.destroyable?
      unless @advertisement.destroy
      alert '删除不成功！'
      else
        render :update do |page|
          page.remove element_id @advertisement
        end
      end
    end
  end

  private

  def find_advertisement
    @advertisement = catch_ad_owner.advertisements.find params[:id]
  end

  def remove_unused_non_text_resource(used_resource_ids, advertisement)
    advertisement.ad_resources.each do |res|
      unless res.is_text_resource or used_resource_ids.include?(res.id)
      advertisement.ad_resources.delete res
      res.destroy
      end
    end
  end

  def link_resource_to_advertisement(resource_id, advertisement)
    resource = AdResource.find resource_id
    return unless current_user == resource.member and resource.advertisement.nil?
    advertisement.ad_resources << resource
  end

  def create_text_resource(advertisement, resource_name, text)
    ad_format = advertisement.ad_format
    return unless ad_format.is_text_resource(resource_name)
    advertisement.ad_resources.create! :member=>current_user, :ad_format=>advertisement.ad_format,
    :name=>resource_name, :text=>text
  end

  def update_text_resource(advertisement, resource_name, text)
    ad_format = advertisement.ad_format
    return unless ad_format.is_text_resource(resource_name)
    old_resource = advertisement.resource_of_name(resource_name)
    if old_resource
    old_resource.update_attributes! :text => text
    else
    advertisement.ad_resources.create! :member=>current_user, :ad_format=>advertisement.ad_format,
    :name=>resource_name, :text=>text
    end
  end

  def reshow_or_replace_tr
    if 'table' == params[:from]
    render :action=>'replace_tr'
    else
    update_page_redirect_to ad_owner_advertisement_url( @advertisement)
    end
  end

  protected
  def expression_for_name(name)
    self.like(:name,name)
  end
  
  def expression_for_status(status)
    self.equal(:status,status)
  end
end
