module Admin::MembersHelper
  def choice_for_account_transaction
        box = [['银行转账',0]]
  end
  
  def choice_for_is_admin
       box = [['请选择',nil],['是',1],['否',0]]
  end
  
  def choice_for_is_ad_owner
       box = [['请选择',nil],['是',1],['否',0]]
  end
  
  def choice_for_is_publisher
       box = [['请选择',nil],['是',1],['否',0]]
  end
  
  def member_status(member)
    status = member.is_a?(Member) ? member.status : member.to_s.to_i
    t "member.status.#{status}"
  end
  
  def choices_member_status
      Member::ALL_STATUS.collect{|t| [member_status_fetch(t),t]}
  end

  def member_status_fetch(status)
      t "member.status.#{status}"
  end
end