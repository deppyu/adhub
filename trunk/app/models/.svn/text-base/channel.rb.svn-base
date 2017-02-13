class Channel < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name,:maximum=>30
  validates_presence_of :ad_container_name
  validates_length_of :ad_container_name,:maximum=>60
  
  has_many :publish_policies
  has_many :ad_containers
end
