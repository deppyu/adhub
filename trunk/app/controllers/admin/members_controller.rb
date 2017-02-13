# -*- coding: utf-8 -*-
require 'dynamic_query'

class Admin::MembersController < Admin::AdminController
    
    include Imon::DynamicQuery
    
    def index
      exps = expressions_from_params params,Member
      @members = Member.paginate :all,:conditions=>self.and(exps).conditions,:order=>'email',:page=>params[:page],:per_page=>10
    end
    
    def show
       @member = Member.find params[:id] 
       if @member
          @account_transactions = AccountTransaction.find :all,:conditions=>['account_id =? and operation =?',@member.id,0],:order=>"created_at desc",:limit=>10
       end
    end
    
    def locked_Or_unlocked
         @member = Member.find params[:id]
         if @member.status != Member::STATUS_LOCKED
              @member.update_attribute (:status,Member::STATUS_LOCKED)
         else
              @member.update_attribute (:status,Member::STATUS_ACTIVE)      
         end 
         @member.reload               
    end
    
    def show_records
        @member = Member.find params[:id]
        if @member
          @account_transactions = AccountTransaction.paginate :all,:conditions=>['account_id =? and operation =?',@member.party.account.id,0],:order=>"created_at desc",
                                  :page =>params[:page],:per_page => 10
        end
    end
    
    def faces
       @member = Member.find params[:id]
    end
    
    def supplement
       @member = Member.find params[:id]
       if  @member
           @account_transaction = AccountTransaction.new
           @account_transaction.account_id = @member.paryt.account.id if @member.party.account
           @account_transaction.operator_id = current_user.id
           @account_transaction.op_way = params[:op_way].to_i
           @account_transaction.amount = params[:amount].to_f

           unless @account_transaction.save
                     flash.now[:notice]= '操作不成功'
                     render :nothing=>true
           else
                        @account_transation.reload
                        @member.party.account.balance += @account_transaction.amount
                        @member.party.save!
                        MemberMailer.account_transaction_note(@member,@account_transaction).deliver
                        flash[:notice] = '操作成功'
                        redirect_to :action => :show          
           end
       end
      
    end
    
  def autocomplete_search
    kw = "%#{params[:term]}%"
    members = Member.find :all, :conditions=>['name like ? or email like ?', kw, kw]
    return_v=[]
    unless members.nil? or members.count==0
        members.each do |member|
        return_v << member.label
        end
    end
    render :json=>return_v
  end

    protected
    def expression_for_name(name)
      self.like :real_name,name      
    end
    
    def expression_for_is_admin(is_admin)
      self.equal (:is_admin,is_admin)
    end
         
    def expression_for_status(status)
       self.equal(:status,status)
    end 
end
