module AdOwner::AdvertisementsHelper
  def advertisement_status(ad)
    status = ad.is_a?(Advertisement) ? ad.status : ad
    t "advertisement.status.#{status}"
  end

  def image_resource(resource, options={})
    return '' if resource.nil? or resource.file.nil?
    image_tag resource.file.url, options
  end

  def text_of_resource(resource)
    resource.nil? ? '' : resource.text
  end
  
  def publsh_policy_status(pp)
    status = pp.is_a?(PublishPolicy) ? pp.status : pp.to_s.to_i
    t "publish_policy.status.#{status}"
  end
end
