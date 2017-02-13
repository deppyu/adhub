# -*- coding: utf-8 -*-
class ContractsController < ApplicationController
  before_filter :authenticated
  before_filter :find_contract, :only=>[:show, :stop, :renewal]
#  before_filter :find_party, :only=>[:stop, :renewal]
#  before_filter :check_party_archived?, :only=>[:stop, :renewal]

  select_main_menu "mnu_agent"
  before_filter :select_menu_check, :only=>[:show]
  before_filter :is_contract_admin?, :only=>[:stop, :renewal]
  layout "default"

  def index
    @active_menu = "mnu_my_company"
  end

  def stop
    @contract.stop!
  end

  def renewal
    params[:contract][:expiration_processed] = 0
    unless @contract.update_attributes params[:contract]
      flash.now[:notice] = "续约失败！"
    end
  end

private
  def find_contract
    @contract = Contract.find params[:id]
  end

  def find_party
    @party = @contract.party
  end

  def select_menu_check
    if @contract.party_id == current_user.party.id
      @active_menu = nil
    end
  end

  def is_contract_admin?
    if @contract.party.agent_id != current_user.party.id
      flash[:notice] = "您不是该业务伙伴的管理员，不能进行此操作。"
      redirect_to :back
    end
  end
end
