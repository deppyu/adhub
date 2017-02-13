require "dynamic_query"
class Admin::PartiesController < Admin::AdminController
  include Imon::DynamicQuery
  before_filter :find_party, :only=>[:show,:save_account]

  def index
    exps = []
    exps << self.less_or_equal("contracts.expired_at", params[:min_expired]) if params[:min_expired] and !params[:min_expired].empty?
    exps << self.like("parties.name", params[:name]) if params[:name] and !params[:name].empty?
    exps << self.equal("parties.party_type", params[:party_type]) if params[:party_type] and !params[:party_type].empty?
    exps << self.not_equal("parties.id", current_user.party.id)
    exps << self.equal("contracts.business_type", params[:contract_business_type]) if params[:contract_business_type] and !params[:contract_business_type].empty?
    exps << self.equal("contracts.expired_at", params[:expired_at]) if params[:expired_at] and !params[:expired_at].empty?
    unless params[:archived] and !params[:archived].empty?
       exps << self.equal("parties.archived", false)
    end
    exps << self.or(self.is_null('parties.agent_id'), self.equal("parties.agent_id", current_user.party.id))
    @parties = Party.paginate :all, :conditions=>self.and(exps).conditions, :include=>"contracts", :order=>"name desc", :page=>params[:page], :per_page=>10
  end

  def show
    
  end

  def stop_contract
    @contract = Contract.find params[:id]
    @contract.stop!
  end
  
  def save_account
    if params[:amount] and params[:amount].to_f >0.0
        unless @party.account.save!(params[:amount].to_f)
          flash.now[:notice] = "充值不成功！"
          render :noting=>true
        else
          flash[:notice] = '充值成功！'
          render :action=>:show  
        end
    else
         flash.now[:notice] ='请正确填写充值金额。'
         render :action=>:show     
    end    
  end

private
  def find_party
    @party = Party.find params[:id]
  end
end
