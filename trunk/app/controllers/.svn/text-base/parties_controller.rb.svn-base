# -*- coding: utf-8 -*-
require 'dynamic_query'
class PartiesController < ApplicationController
  include Imon::DynamicQuery
  layout "default"

  before_filter :authenticated
  before_filter :find_party, :only=>[:show, :edit, :update, :destroy, :archived]
  #before_filter :check_party_archived?, :only=>[:edit, :update, :destroy, :archived]

#  require_privilege :query_customer, :only=>[:index]
  require_privilege :modify_party, :only=>[:show, :edit, :update, :destroy, :archived], :data_object=>:@party
  require_privilege :new_party, :only=>[:new, :create]

  before_filter :check_privilege
  before_filter :choose_main_menu

  def index
    exps = []
    exps << self.like('parties.name', params[:name]) if params[:name] and !params[:name].empty?
    exps << self.equal('contracts.business_type', Contract::BUSINESS_TYPE_AD_OWNER)
    exps << self.equal('parties.party_type', params[:party_type]) if params[:party_type] and  !params[:party_type].empty?
    exps << self.less_or_equal('contracts.expired_at', Date.strptime(params[:expired_at])) if params[:expired_at] and !params[:expired_at].empty?
    unless params[:archived] and !params[:archived].empty?
      exps << self.equal('parties.archived', false)
    end
    exps << self.equal('parties.agent_id', current_user.party.id)
    ids = []
    if (params[:account_min] and !params[:account_min].empty?) or (params[:account_max] and !params[:account_max].empty?)
      if (params[:account_min] and !params[:account_min].empty?) and (params[:account_max] and !params[:account_max].empty?)
        accounts = Account.find_by_sql ["select party_id from accounts where balance between ? and ?", params[:account_min], params[:account_max]]
        accounts.collect {|a| ids << a.party_id }
      else
        if params[:account_min] and !params[:account_min].empty? 
          accounts = Account.find_by_sql ["select party_id from accounts where balance >= ?", params[:account_min]]
          accounts.collect {|a| ids << a.party_id }

        end
        if params[:account_max] and !params[:account_max].empty?
          accounts = Account.find_by_sql ["select party_id from accounts where balance <= ?", params[:account_max]]
          accounts.collect {|a| ids << a.party_id }
        end
      end
      exps << self.in("parties.id", ids) if ids.count>0
      exps << self.in("parties.id", [-1]) if ids.count==0
    end

    @parties = Party.paginate :all, :conditions=>self.and(exps).conditions, :include=>:contracts, :order=>"parties.created_at desc", :page=>params[:page], :per_page=>20
  end

  def new
    @party = Party.new
    unless current_user.party.nil?
      @contract = @party.contracts.new
      @contract.start_from = Date.today
      @contract.expired_at = Date.today.next_year
    end
  end

  def create
    @party = Party.new params[:party]
    @party.adhub_operator = false
    @party.agent = current_user.party if current_user.party
    Party.transaction do
      if @party.save!
        if current_user.party.nil?
          current_user.party=@party
          current_user.save!
          current_user.roles << ::Role.find_by_code(:admin)
        else
          if params[:contract]['start_from'].nil? or params[:contract]['start_from'].empty?
            params[:contract]['start_from'] = Time.now.to_date
          end # if params..start_from..
          if params[:contract]['expired_at'].nil? or params[:contract]['expired_at'].empty?
            params[:contract]['expired_at'] = Time.now.next_year.to_date
          end # if params..expired_at..
          @contract = @party.contracts.build params[:contract]
          @contract.business_type = Contract::BUSINESS_TYPE_AD_OWNER

          if @contract.save!
            redirect_to parties_path(:format=>:html)
          else
            render :action=>:new
            return
          end # if @contract.save
          return
        end
        redirect_to main_url
      end # if @party.save!
    end # .. transaction ..
    rescue ActiveRecord::RecordInvalid
      render :action => :new
  end # def create

  def update
    if params[:sales_email] and !params[:sales_email].empty?
      sales = current_user.party.members.where("id in (select member_id as id from members_roles where role_id = #{::Role::ROLE_SALES})").find_by_email params[:sales_email]
      if sales
        params[:party]['sales_id'] = sales.id
      else
        flash[:notice] = "您的公司没有该业务员，编辑失败！"
        render :action=>:edit
        return
      end
    end
    if @party.update_attributes params[:party]
      flash[:notice]="修改成功！"
      redirect_to :action=>:edit
    else
      render :action=>:edit
    end
  end

  def autocomplete_search
    members = current_user.party.members.where("id in (select member_id as id from members_roles where role_id = #{::Role::ROLE_SALES})").find :all, :conditions=>['email like ?', "%#{params[:term]}%"]
    return_v=[]
    unless members.count == 0
      members.collect {|m| return_v << m.email }
    end #unless
    render :json=>return_v
  end # def autocomplete_search

  def destroy
    if @party.destroyable?
      @party.destroy
    else
      flash[:notice]="此广告客户已经发布过广告，无法删除，只能中止合约！"
    end
  end

  def archived
    if @party.can_archived?
      @party.archived=true
      @party.save!
      logger.info "now archived party.id is #{@party.id}"
    else
      alert "合约没有中止，不能归档!"
    end
  end

  private
  def find_party
    @party = Party.find params[:id]
  end

  def choose_main_menu
    if current_user.party.nil?
      @active_menu = nil
    elsif current_user.party == @party
      @active_menu = 'mnu_my_company'
    else
      @active_menu = 'mnu_agent'
    end
  end
end
