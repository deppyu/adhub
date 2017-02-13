# -*- coding: utf-8 -*-
class Publisher::PricesController < Publisher::PublisherController
  before_filter :find_price, :only=>[:edit, :update, :destroy]
  layout 'default', :except=>[:edit, :new]

  def index
    @prices = current_user.party.prices
  end

  def new
    @price = Price.new 
    @price.pay_method = PayMethod.find params[:pay_method_id]
    @price.channel = Channel.find params[:channel_id] if params[:channel_id]
  end

  def create
    @price = Price.new params[:price]
    @price.party = current_user.party
    unless @price.save
      open_dialog_with_form_error :price      
    end
  end

  def update
    unless @price.update_attributes params[:price]
      flash.now[:notice]="编辑失败！"
      open_dialog_with_form_error :price
    end
  end

  def destroy
    unless @price.destroy
      flash.now[:notice] = "删除失败！"
    end
  end

private
  def find_price
    @price = Price.find params[:id]
  end
end
