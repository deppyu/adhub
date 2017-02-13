# encoding: UTF-8
class MemberMailer < ActionMailer::Base
  default :from=>Adhub::MAIL_FROM
  
  def activation(member)
    @member = member
    @url = active_member_url(member, :format=>:html, :activation_code=>member.activation_code, :host=>Adhub::HOST_NAME)
    mail :to=>member.email, :subject=>'AdHub账号激活邮件'
  end
  
  def send_password(member,password)
    @member = member
    @password = password
    
    mail :to=>@member.email,:subject=>'AdHub:找回密码'
  end

  def company_activation(party, member, password)
    @party = party
    @member = member
    @password = password
    @url = active_member_url(member, :format=>:html, :activation_code=>member.activation_code, :host=>Adhub::HOST_NAME)
    mail :to=>@member.email,:subject=>'AdHub:AdHub账号激活邮件'
  end
  
  def account_transaction_note(member,account_transaction)
    @member = member
    @account_transaction = account_transaction
    
    mail :to=>@member.email,:subject=>'AdHub:充值通知'
  end
  
  def send_cash_claim_info(cash_claim)
    @cash_claim = cash_claim
    
    mail :to=>@cash_claim.member.email,:subject=>'AdHub:提现要求驳回原因'
  end
  
  def send_dynamic_pass(member,dynamic_pass)
    @member = member
    @dynamic_pass = dynamic_pass
    
    mail :to=>@member.email,:subject=>'AdHub：获得动态密码'
  end
  
  def send_bank_account_info(bank_account, member)
    @bank_account = bank_account
    @member = member    
    mail :to=>member.email,:subject=>"AdHub：银行账户信息"
  end
end
