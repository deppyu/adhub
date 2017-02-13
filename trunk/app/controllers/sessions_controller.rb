# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  layout 'default'

  def new
    if session[:login_forward_to]
      @forward_to = session[:login_forward_to]
    else
      referer = request.env['HTTP_REFERER']
      @forward_to = params[:forward_to] || referer unless referer.nil? or referer =~ /(session)|(members)\/new/ or URI.parse(referer).host != request.env['HTTP_HOST']
    end    
    respond_to do |format|
      format.html
      format.mobile { render :layout=>'mobile' }
    end
  end

  def create
    if params[:email].nil? or params[:email].empty? 
      redirect_to :action=>:new
      return
    end
    fail_count = session[:fail_count] || 0
    logger.info "fail_count = #{fail_count}"

    unless 0 == fail_count
      unless simple_captcha_valid?
        flash.now[:notice] = '验证码错误。'
        render :action=>:new
        return
      end
    end
    
    @forward_to = params[:forward_to]
    member =  Member.login params[:email], params[:password]
    # TODO check member's status
    unless member.nil?
      @current_user = member
      logged_in(member)
      remember_user(@current_user) if '1' == params[:remember_me]
      session[:fail_count] = 0
      if member.party.nil?
          redirect_to '/parties/new.html'
          return
      end
      if @forward_to
        redirect_to params[:forward_to]
        session[:login_forward_to] = nil
      else
        redirect_to '/'
      end
    else
      session[:fail_count] = fail_count + 1
      flash[:notice] = '用户名或密码错误。'
      render :action=>:new
    end
  end
  
  def destroy
    session[:member_id] = nil
    cookies.delete :remember_me
    update_page_redirect_to '/'
  end

  private 
  def remember_user(user, expire_time=30)
    cookies[:remember_me]={ :value=>"#{user.id}:#{user.digest}",
                            :expires=>expire_time.days.from_now }
  end
end
