class PayMethod < ActiveRecord::Base
  PAY_ON_SHOW = 0
  PAY_ON_CLICK = 1

  def pay_on_show?
    PAY_ON_SHOW == self.pay_on
  end

  def pay_on_click?
    PAY_ON_CLICK == self.pay_on
  end
end
