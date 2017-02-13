# -*- coding: utf-8 -*-
class Admin::ContractsController < Admin::AdminController
  before_filter :find_contract, :only=>[:show, :renewal, :stop]
  before_filter :find_party

  def stop
    @contract.stop!
    render :template=>'admin/parties/stop_contract'
  end

  def new
    @contract = @party.contracts.new :business_type=>params[:business_type], :start_from=>Date.today, :expired_at=>Date.today.next_year
  end

  def create
    @contract = @party.contracts.build params[:contract]
    begin
      Contract.transaction do 
        @contract.save!
        if Contract::BUSINESS_TYPE_AD_OWNER == @contract.business_type
          @contract.party.update_attribute :agent_id, current_user.party_id
        end
        redirect_to admin_party_path(@contract.party, :format=>:html)
      end
    rescue ActiveRecord::RecordInvalid
      render :new
    end
  end

  def renewal
    params[:contract][:expiration_processed] = 0
    unless @contract.update_attributes params[:contract]
      flash.now[:notice] = "续约失败！"
      render :action=>:show
    else
      redirect_to admin_party_path(@contract.party, :format=>:html)
    end
  end

private
  def find_contract
    @contract = Contract.find params[:id]
  end

  def find_party
    @party = Party.find params[:party_id] if params[:party_id]
  end
end
