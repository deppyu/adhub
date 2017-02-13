require 'dynamic_query'
require 'date' 

class Admin::AccountTransactionsController < Admin::AdminController
  include Imon::DynamicQuery
  
  def index
    exps = expressions_from_params params, AccountTransaction
    
    if params[:start_time]!=nil && params[:start_time] !="" and  params[:over_time]!=nil && params[:over_time] !=""    
      exps << self.between(:created_at,Date.strptime(params[:start_time]),Date.strptime(params[:over_time])+1)
    end
    
    @account_transactions = AccountTransaction.paginate :all,:conditions=>self.and(exps).conditions,:order=>'created_at desc',
                                :page=>params[:page],:per_page=>10
  end
  
  protected
  def expression_for_operation(operation)
    self.equal(:operation,operation)
  end
end