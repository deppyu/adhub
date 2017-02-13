# -*- coding: utf-8 -*-
require 'dynamic_query'

class Admin::AdContainersController < Admin::AdminController
  include Imon::DynamicQuery
  
  def index  
    party_id = AdContainer::find_party_id params[:party] if params[:party]  
    exps = expressions_from_params params,AdContainer
    exps << self.equal(:party_id,party_id) if party_id 
    @applications = AdContainer.paginate :all,:conditions=>self.and(exps).conditions,:order=>'name',:page=>params[:page],:per_page=>10  
  end
  
  def show
    @application = AdContainer.find params[:id]
  end
  
  def approve
    @application = AdContainer.find params[:id]
    begin
      approve_log = ApproveLog.new :member=>current_user,:result=>params[:result].to_i,:opinion=>params[:opinion],
      :target=>@application
      approve_log.save!
      @application.update_attribute :status, (approve_log.approved? ? AdContainer::STATUS_ACTIVE : AdContainer::STATUS_DISAPPROVED)
      redirect_to :action=>:show
    rescue ActiveRecord::RecordInvalid => e
      render :action=>:show
    end
  end  
  
  protected
  def expression_for_name(name)
      self.like :name,name
  end
  
  def expression_for_status(status)
      self.equal :status,status
  end
  
end
