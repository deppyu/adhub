class Price < ActiveRecord::Base
  belongs_to :pay_method
  belongs_to :channel
  belongs_to :party

  validates_presence_of :base_price
  validates_numericality_of :base_price, :greater_than_or_equal_to=>0

end
