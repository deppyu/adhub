# -*- coding: utf-8 -*-
require 'dynamic_query'
require 'date'

class MembersController < ApplicationController
  include Imon::DynamicQuery
  layout 'default'
  select_main_menu 'mnu_my_account'

  def new
    @member = Member.new
  end

  def create
    @member = Member.new params[:member]
    @member.status = Member::STATUS_REGISTERED
    @member.generate_activation_code
    if @member.save
      MemberMailer.activation(@member).deliver
    else
      render :action=>:new
    end
  end
  
  def update
     @member = Member.find params[:id]
     unless @member.update_attributes params[:member]
       alert '编辑不成功！'
       render '/ad_owner'
     else
       render :update do |page|
        if params[:forward_to].nil? or params[:forward_to].empty?
         page.alert '编辑成功！'
        else
          page.redirect_to params[:forward_to]
        end
       end       
     end 
  end
  
  def edit
    @member = current_user
  end
  
  def active
    member = Member.find params[:id]
    if member.activation_code == params[:activation_code]
      member.active!
      flash[:notice] = "您的帐号已经激活，您现在可以正常登录了。"
      redirect_to new_session_url(:format=>:html)
    else
      flash[:notice] = "激活码不正确。"
      redirect_to '/'
    end    
  end
  
  def modify_passwd
    @member = current_user
  end
  
  def update_passwd
    @member = current_user
     if @member.password_hash == Imon::ActiveRecord::Password::encrypt(params[:passwd])
        if params[:new_passwd] == params[:confirm_passwd]
           unless @member.update_attribute(:password_hash,Imon::ActiveRecord::Password::encrypt(params[:new_passwd]))
             alert '修改密码不成功！'
           else
             render :update do |page|
               page.alert '修改密码成功！'
             end
             #render :nothing=>true
           end
        else
          alert '输入新密码不一致！'
        end
    else
      alert '原有密码不正确！'
    end
  end
  
  def faces
       @member = current_user
  end
    
    def supplement
       @member = current_user
       if  @member
           @account_transaction = AccountTransaction.new
           @account_transaction.member_id = @member.id
           @account_transaction.operator_id = current_user.id
           @account_transaction.op_way = params[:op_way].to_i
           @account_transaction.amount = params[:amount].to_f
           @account_transaction.balance = @member.account_balance + params[:amount].to_f
           # @account_transaction.reload
           unless @account_transaction.save
                     flash.now[:notice]= '操作不成功'
           else
                        @member.account_balance = @account_transaction.balance
                        @member.save!
                        flash[:notice] = '操作成功'
                        render :action => :edit          
           end
       end       
    end

  def check_email
    email = nil
    email = params[:member][:email] if params[:member]
    unless email.nil? or email.empty?
      cnt = Member.count :conditions=>['email = ? and id <> ? ', email, params[:id]] unless params[:id].nil? or params[:id].empty?
      cnt = Member.count :conditions=>['email = ? ', email ] if params[:id].nil? or params[:id].empty?
      render :text=>(cnt == 0), :layout=>false
    else
      render :text=>'true', :layout=>false
    end
  end
  
  def resend_active_email
    member = Member.find_by_email params[:email]
    if member
      unless MemberMailer.activation(member).deliver
          alert '邮件发送不成功！'
      else
         render :update do |page|
              page.alert '邮件发送成功！'
         end        
      end
    end
  end

  def forget_password_form
    member = Member.find_by_sql("select * from members m where email= '#{params[:email]}'").first
    if member.nil?
      alert '邮箱错误！请重新输入邮箱地址'
    else
      new_passwd = member.reset_passwd
      MemberMailer.send_password(member, new_passwd).deliver
      render :update do |page|
        page.alert '新密码已经发送到你注册邮箱！'
      end
    end
  end
end
