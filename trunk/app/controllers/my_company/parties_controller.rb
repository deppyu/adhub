require 'dynamic_query'
class MyCompany::PartiesController < MyCompany::MyCompanyController
  include Imon::DynamicQuery
  layout 'default'

  def show_account_transactions
    @party = current_user.party
    if @party.account.nil?
      @party.create_account
    end
    exps = expressions_from_params params, AccountTransaction
    over_time = Date.strptime(params[:over_time])+1  if params[:over_time]
    start_time = Date.strptime(params[:start_time]) if params[:start_time]
    exps = self.between(:created_at,start_time,over_time) if params[:start_time] 
    @account_transactions = @party.account.account_transactions.paginate :all,
      :conditions=>self.and(exps).conditions,
      :order=>'created_at desc',:page=>params[:page],
      :per_page=>10
  end
end
