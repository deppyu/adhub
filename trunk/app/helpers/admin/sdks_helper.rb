module Admin::SdksHelper
  
  def sdk_os_type(sdk)
    os_type = sdk.is_a?(Sdk) ? sdk.os_type : os_type.to_s.to_i
    t "sdk.os_type.#{os_type}"
  end
  
  def sdk_status(sdk)
    status = sdk.is_a?(Sdk) ? sdk.status : status.to_s.to_i
    t "sdk.status.#{status}"
  end
  
  def choice_sdk_os_type
    Sdk::ALL_OS_TYPE.collect{|e|[sdk_os_type_fetch(e),e]}
  end
  
  def sdk_os_type_fetch(os_type)
      t "sdk.os_type.#{os_type}"
  end
  
  def choice_sdk_status
    Sdk::ALL_STATUS.collect{|e|[sdk_status_fetch(e),e]}
  end
  
  def sdk_status_fetch(status)
      t "sdk.status.#{status}"
  end
  
  def choice_sdk_active
    box =[['是',1],['否',0]]
  end
end