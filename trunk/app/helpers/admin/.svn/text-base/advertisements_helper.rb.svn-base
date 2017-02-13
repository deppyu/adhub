module Admin::AdvertisementsHelper
  
  def  choice_for_ad_status
    Advertisement::ALL_STATUS.collect{|t| [advertisement_status_fetch(t),t]}
  end  
  
  def advertisement_status_fetch(status)
       t "advertisement.status.#{status}"
  end
end
