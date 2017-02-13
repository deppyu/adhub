class ApproveLog < ActiveRecord::Base
  APPROVE = 0
  DISAPPROVE = 1

  belongs_to :member
  belongs_to :target, :polymorphic=>true

  def approved?
    APPROVE == self.result
  end
end
