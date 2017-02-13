# -*- coding: utf-8 -*-
class ApproveLogsController < ApplicationController
  before_filter :authenticated
  before_filter :find_target
  before_filter :check_privilege

  layout 'default', :except =>[:index]
  
  def index
    @approve_logs = @target.approve_logs
  end
  
  private
  def find_target
    @target = class_for_name(params[:target_type]).find params[:target_id]
  end

  def check_privilege
    if current_user.is_admin or @target.party == current_user.party
      return true
    else
      render :text=>'您没有执行此操作的权限。'
      return false
    end
  end
end
