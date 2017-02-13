# -*- coding: utf-8 -*-
require 'dynamic_query'
class MyCompany::MembersController < MyCompany::MyCompanyController
  include Imon::DynamicQuery
  layout "default"
  select_main_menu "mnu_my_company"
  before_filter :find_member, :only=>[:edit, :update, :lock, :unlock, :reset_passwd]
  require_privilege :manage_employee, :data_object=>:@party
  before_filter :check_privilege

  def index
    exps = []
    exps << self.like("members.email", params[:email]) if params[:email] and !params[:email].empty?
    exps << self.like("members.real_name", params[:real_name]) if params[:real_name] and !params[:real_name].empty?
    exps << self.exists("select * from members_roles mr where mr.member_id = members.id and mr.role_id = ?", params[:role_id] ) if params[:role_id] and !params[:role_id].empty?
    @members = current_user.party.members.paginate :conditions=>self.and(exps).conditions, :order=>"email", :page=>params[:page], :per_page=>15
  end # def index

  def create
    @member = Member.new params[:member]
    @member.party = current_user.party
    Member.transaction do 
      pwd = @member.new_passwd
      @member.password = pwd
      unless @member.save
        flash.now[:notice] = "员工帐号创建失败！"
        render :action=>:new
      else
        MemberMailer.company_activation(current_user.party, @member, pwd).deliver
        flash[:notice] = "员工帐号创建成功！"
        redirect_to :action=>:index
      end # unless @member.save
    end # transaction
  end # def create

  def update
    if @member.update_attributes params[:member]
      flash[:notice] = "员工信息编辑成功"
      redirect_to :action=>:index
    else
      flash.now[:notice] = "员工信息编辑失败！"
      render :action=>:edit
    end # if ... update...
  end # def update

  def reset_passwd
    if @member.nil?
      alert "邮箱错误,请重新输入邮箱地址!"
    else
      new_passwd = @member.reset_passwd
      MemberMailer.send_password(@member, new_passwd).deliver
      render :index do |page|
        page.alert '新密码已经发送到你注册邮箱！'
      end #render
    end # if
  end # def reset_passwd

  def lock
    if @member.update_attribute :status, Member::STATUS_LOCKED
      render :text=>"success"
    else
      render :text=>"fail"
    end # if ...LOCKED
  end # def lock

  def unlock
    if @member.update_attribute :status, Member::STATUS_ACTIVE
      render :text => Member::STATUS_ACTIVE
    else
      render :text => "fail"
    end # if ... ACTIVE
  end # def unlock

private
  def find_member
    @member = Member.find params[:id]
  end
end
