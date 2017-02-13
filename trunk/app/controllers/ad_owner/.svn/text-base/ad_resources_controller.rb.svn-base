# -*- coding: utf-8 -*-
class AdOwner::AdResourcesController < AdOwner::AdOwnerController
  layout nil

  before_filter :find_ad_format, :only=>[:new, :upload]
  
  def index
    @advertiesments = catch_ad_owner.advertiesments.paginate :order=>'name',:page=>params[:page],:per_page=>10
  end

  def new
    render :action=>"new_#{@ad_format.name}"
  end
   
  def upload
    begin
      @ad_format.check_file_type(params[:resource_name], params[:Filename])
    rescue ArgumentError => ex
      render :json=>{ :error => ex.message }
      return
    end

    @resource = AdResource.new :ad_format => @ad_format, :name=>params[:resource_name], :member=>current_user
    @resource.file= params[:resource_file]
    logger.info "resource name is #{@resource.name}"
    logger.info "is image resource? #{@resource.ad_format.is_image_resource(@resource.name)}"
    if @resource.ad_format.is_image_resource(@resource.name)
      logger.info 'find size code now'
      begin
        @resource.size_code = @resource.ad_format.size_code_for_resource_image(@resource.name, @resource.file).to_s
      rescue ArgumentError => ex
        render :json=> { :error=> ex.message }
        return
      end
    end
    if @resource.save
      render :json=>{ :resource_id=> @resource.id, :url=>@resource.file.url, 
        :name=>@resource.name, :format=>@ad_format.name, :size=>@resource.size_code }
    else
      render :json=>{ :error=>@resource.errors.full_messages.join("\n") }
    end
  end

  def destroy
    @ad_resource = current_user.ad_resources.find params[:id]
    if @ad_resource.advertisement.nil? or (@ad_resource.advertisement.editing?)
      @ad_resource.destroy
    else
      alert '现在不能执行此操作。'
    end
  end

  private

  def find_ad_format
    @ad_format = AdFormat.of_name params[:ad_format]
    raise ActiveRecord::RecordNotFound if @ad_format.nil?
  end
end
