# -*- coding: utf-8 -*-
class Publisher::BankAccountsController < Publisher::PublisherController
  layout 'default'
  before_filter :find_member
  
  def index
    @bank_accounts = @member.party.bank_accounts
    if @member.party.account
       @account_transactions = @member.party.account.account_transactions.where(:operation =>AccountTransaction::RETRIEVE_CASH).order('created_at desc').limit(6)
    end
  end
  
  def new
    @bank_account = @member.party.bank_accounts.new 
  end
  
  def create
    @bank_account = @member.party.bank_accounts.new params[:bank_account]
    if session[:dynamic_pass]
      if session[:dynamic_pass]!=nil && session[:dynamic_pass]!=""
        if session[:dynamic_pass] == params[:dynamic_pass]      
          @bank_account = @member.party.bank_accounts.new params[:bank_account]
          if @bank_account.save
            MemberMailer.send_bank_account_info(@bank_account, current_user).deliver
            session[:dynamic_pass] = nil
            flash[:notice] = '保存成功。' 
            redirect_to :action=>:index
            return
          end     
        else
          flash.now[:notice] = '动态密码填写错误。请重新输入。'            
        end
      else
        flash.now[:notice] = '请填写动态密码'            
      end 
    else
      flash.now[:notice] = '请先获取动态密码，再完成操作。'

    end
    render :action =>:new
  end
  
  def show_ex
    
  end
  
  def edit
    @bank_account = BankAccount.find params[:id]
  end
  
  def update
    @bank_account = BankAccount.find params[:id]
   if session[:dynamic_pass] 
    if session[:dynamic_pass]!=nil && session[:dynamic_pass]!=""
       if session[:dynamic_pass] == params[:dynamic_pass]    

            if params[:bank_account][:bank_serial] ==  params[:bank_serial_confirm]
                if @bank_account.update_attributes params[:bank_account]
                  MemberMailer.send_bank_account_info(@bank_account, current_user).deliver
                  session[:dynamic_pass] = nil
                  redirect_to :action=>:index
                  return
                end
            else
                flash.now[:notice] ='两次输入的银行帐号不一致。'
            end
            
      else
            flash.now[:notice] = '动态密码填写错误。请重新输入。'
      end    
     else
        flash.now[:notice] = '请填写动态密码。'
     end 
    else
      flash.now[:notice] = '请先获取动态密码，再完成操作。'
    end      
    render :action =>:edit
  end
  
  def destroy
    @bank_account = BankAccount.find params[:id]
    unless @bank_account.destroy
      alert '删除失败！'
    else
      render :update do |page|
        page.remove element_id @bank_account
      end
    end
  end
  
  def send_dynamic_pass
    @dynamic_pass = dynamic_pass(len = 6)
    logger.info @dynamic_pass
    if MemberMailer.send_dynamic_pass(@member,@dynamic_pass).deliver
      if session[:dynamic_pass]        
        session[:dynamic_pass] = @dynamic_pass
      else
        session[:dynamic_pass] = {}
        session[:dynamic_pass] = @dynamic_pass
      end
      
      render :update do |page|
        page.alert "获取成功！动态密码已经发送到了您的注册邮箱！"
      end
    else
      alert '动态口令发送失败！'
    end    
  end
  
  private
  def find_member
      @member = current_user
  end
  
  def verify_account_name_and_bank_serial(bank_name,bank_serial)        
      current_user.bank_accounts.where(:bank_name=>bank_name, :bank_serial=>bank_serial).first   
  end 
end
