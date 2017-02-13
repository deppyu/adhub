# -*- coding: utf-8 -*-
require 'security_manager'

class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  include Fusion::Security

  protect_from_forgery
  
  helper :all # include all helpers, all the time
  helper_method 'authenticated?', :current_user, :element_id, :class_name_for_url, :main_menu
  
  before_filter :probe_client
  before_filter :find_current_user

  MENUS = []

  class SelectMainMenuFilter
    def initialize(menu_name)
      @menu_name = menu_name
    end

    def filter(controller)
      controller.instance_variable_set(:@active_menu, @menu_name)
      true
    end
  end

  def main_menu
    menu = []
    if authenticated?
      menu.concat MENUS
      menu << { :label=>'我的账户', :name=>'mnu_my_account', :url=>"/members/my_account"}
      if current_user.party
        menu << { :label=>'我的公司', :name=>'mnu_my_company', :url=>party_path(current_user.party, :format=>:html)}

        if current_user.party.is_valid_agent? && current_user.has_many_ad_owners?
          menu << { :label=>'广告主', :name=>'mnu_ad_owner', :url=>'/ad_owner/console/select_ad_owner'}
        elsif current_user.party and current_user.party.is_valid_ad_owner?         
          menu << { :label=>'广告主', :name=>'mnu_ad_owner', :url=>'/ad_owner'}
        end 

        menu << { :label=>'发行商', :name=>'mnu_publisher', :url=>'/publisher'} if current_user.party.is_valid_publisher?
        menu << { :label=>'代理商', :name=>'mnu_agent', :url=>agent_path(:format=>:html)} if current_user.party.is_valid_agent?
      end

      menu << { :label=>'管理后台', :name=>'mnu_admin', :url=>admin_members_url(:format=>:html)} if current_user.is_admin 
    end
    menu
  end

  def self.select_main_menu(menu_name, options={})
    logger.info "select main menu #{menu_name}"
    before_filter SelectMainMenuFilter.new(menu_name), options
  end

  def probe_client
    request.format = :mobile if env and env['HTTP_USER_AGENT'] and env['HTTP_USER_AGENT'] =~ /iPhone/
  end

  def find_current_user      
    # logger.info "UserAgent: #{env['HTTP_USER_AGENT']}"
    return true if request.format == Mime::XML
     if member_id = session[:member_id]
      @current_user= Member.find(member_id)
    else
      @current_user= find_remembered_user
    end                   
  end     

  def authenticated
    return true if @current_user
    if request.format == Mime::HTML or request.xhr?
      session[:login_forward_to] = request.request_uri
      redirect_to new_session_url 
      return false
    end
    authenticate_or_request_with_http_digest Adhub::HTTP_DIGEST_REALM do |username|
      (@current_user = Member.find_by_login_name(username)).try(:ha1)
    end
    return ! @current_user.nil?
  end

  def logged_in(member) 
    session[:member_id] = member.id
  end
  
  protected
  def find_remembered_user
    if cookies[:remember_me]
      member_id, digest = cookies[:remember_me].split ':'
      @current_user= Member.find(member_id.to_i)
      if current_user.digest == digest
        logged_in(current_user)
        # TODO : check member status
        return current_user
      end
    end    
    return nil
  end


  def authenticated?
    return ! @current_user.nil?
  end
  
  def current_user
    @current_user
  end
  
  def current_user=(user)
    logger.info "current_user= #{user}"
    @current_user = user
  end
  
  def is_admin
    return true if current_user.is_admin
    flash[:notice] = "您没有执行这个操作的权限。"
    redirect_to '/'
    return false
  end

  def reopen_dialog(msg)
    flash.now[:notice] = msg
    render :update do |page|
      page << "$('#dialog .message').html('#{msg}');"
      page << "$('#dialog').dialog('open');"
    end
  end
  
  def show_form_error(model)
    @model = model
    render :file=>'/form_error'
  end
  
  def alert(msg)
    respond_to do |format|
      format.js { 
        render :update  do |page| 
          page.alert msg 
        end
     }
     
     format.html {
       render :file=>'/alert', :layout=>false
     }
    end
  end
  
  def element_id(obj)
    "ele_#{obj.class.to_s}_#{obj.id}"
  end                 
  
  def class_name_for_url(obj)
    clazz = obj.is_a?(Class) ? obj : obj.class
    clazz.to_s.underscore
  end
  
  def class_for_name(name)
    name.camelize.split("::").inject(Object) { |par, const| par.const_get(const) }
  end
  
  def update_page_redirect_to(url)
    render :update do |page|
      page.redirect_to url
    end
  end

  def parse_date(date_string)
    return nil if date_string.nil? or date_string.empty?
    Date.parse date_string
  end
  
  def dynamic_pass(len)
    tokens = ("0".."9").to_a
    rand_str = ""  
    1.upto(len) { |i| rand_str << tokens[rand(tokens.size-1)] }  
    return rand_str  
  end
  
  def party_is_null?
    if current_user.party.nil?
      redirect_to '/parties/new.html'
      return
    end
  end

  def open_dialog_with_form_error(model)
    @model_name = model
    render :template=>'/open_dialog_with_form_error', :layout=>false
  end

#  def check_party_archived?
#    if @party.archived
#      error_msg = "已经归档，不能修改!"
#      respond_to do |format|
#        format.html {
#          flash[:notice]= error_msg
#          redirect_to :back
#        }
#        format.js {
#          alert error_msg
#        }
#      end # respond_to..
#    end # if @party.archived
#  end # def check_party_archived?
end
