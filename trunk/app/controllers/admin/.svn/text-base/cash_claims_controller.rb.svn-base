# encoding: UTF-8
require 'dynamic_query'
class Admin::CashClaimsController < Admin::AdminController
  include Imon::DynamicQuery
  layout 'default'

  before_filter :find_cash_claim, :except=>[:index]
  def index
    exps = self.expressions_from_params params, CashClaim
    logger.info "exps.empty? #{exps.empty?}"
    @cash_claims = CashClaim.paginate :conditions=>self.and(exps).conditions,
    :order=>'cash_claims.created_at', :page=>params[:page], :per_page=>20, :include=>:member
  end

  def update
    case params[:result]
    when '1'
      unless params[:bill_no].nil? or params[:bill_no].empty?
        @cash_claim.succeed params[:bill_no], current_user
      else
        flash.now[:notice] = '请输入银行回单号。'
        render :action=>:show
        return
      end
    
    when '2'
      unless params[:fail_reason].nil? or params[:fail_reason].empty?
        @cash_claim.failed params[:fail_reason], current_user
        MemberMailer.send_cash_claim_info(@cash_claim).deliver
      else
        flash.now[:notice] = '请输入失败原因。'
        render :action=>:show
        return
      end
    else
        flash.now[:notice] = '请选择处理结果。'
        render :action=>:show
        return      
    end
   redirect_to :action=>:show
  end

  protected
  def find_cash_claim
    @cash_claim = CashClaim.find params[:id]
  end

  def expression_for_keyword(keyword)
    self.or(self.like('members.name', keyword),
            self.like('members.email', keyword))
  end

  def expression_for_start_from(date)
    self.greater_or_equal('cash_claims.created_at', date)
  end

  def expression_for_end_to(date)
    self.less_or_equal('cash_claims.created_at', date)
  end

end
