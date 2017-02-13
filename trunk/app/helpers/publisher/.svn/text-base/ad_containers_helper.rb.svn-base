# -*- coding: utf-8 -*-
module Publisher::AdContainersHelper
  
  def choice_for_os_type
    Application::ALL_OS_TYPE.collect{|t|[application_for_fetch(t),t]}
  end
  
  def choice_for_status
    Application::ALL_STATUS.collect{|t|[application_for_status(t),t]}
  end
  
  def application_for_fetch(os_type)
    t "application.os_type.#{os_type}"
  end
  
  def application_for_status(status)
    t "application.status.#{status}"
  end
  
  def approve_application
    box = [['审核通过',1],['审核拒绝',0]]
  end
  
  def application_status(application)
     status = application.is_a?(Application) ? application.status : application.to_s.to_i
     t "application.status.#{status}"
  end
end
