class Application < AdContainer
  OS_ANDROID = 0

  ALL_OS_TYPE= [OS_ANDROID]
  
  ALL_STATUS = [STATUS_EDITING,STATUS_ACTIVE,STATUS_LOCKED,STATUS_DISAPPROVED]
  
  validates_presence_of :url
  validates_length_of :url, :maximum=>512
  validates_presence_of :name
  validates_length_of :name,:maximum=>80
  validates_presence_of :description
  validates_length_of :description,:maximum=>1400
  
end
