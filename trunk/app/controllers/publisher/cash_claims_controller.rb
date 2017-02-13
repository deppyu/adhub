# -*- coding: utf-8 -*-
require 'ad_show_control' 

class Publisher::CashClaimsController < Publisher::PublisherController
  layout 'default'

  def new
    if current_user.party.bank_accounts.empty?
      flash[:notice] = '请先设置银行账号。'
      redirect_to new_publisher_bank_account_path(:format=>:html)
      return
    end
    @low_limit = SystemParameter.find_or_create('claim_cash_low_limit', SystemParameter::INT_PARAM).value
    @account = current_user.party.account
    if @account.nil?
      @account = current_user.party.create_account
    end
    @cash_claim = current_user.party.account.cash_claims.new :amount=>@low_limit
  end

  def create
    @low_limit = SystemParameter.find_or_create('claim_cash_low_limit', SystemParameter::INT_PARAM).value
    @cash_claim = current_user.party.account.cash_claims.new params[:cash_claim]
    amount = params[:cash_claim][:amount].to_f
    bank_account = current_user.party.bank_accounts.find params[:bank_account_id]
    begin
      current_user.party.account.claim_cash amount, bank_account
      flash[:notice] = '您的提款请求已经提交。我们会尽快为您安排转账。'
    rescue NoEnoughBalance
      flash[:notice] = '没有足够的账户余额。'
      render :new
      return
    end
    redirect_to publisher_bank_accounts_path(:format=>:html)
  end
end
