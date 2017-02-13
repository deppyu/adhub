module AdOwner::CampaignsHelper
  def campaign_status_icon(campaign)
    if campaign.running?
      image = 'campaign_running.png'
    else
      image = 'campaign_stopped.png'
    end
    image_tag image
  end
end
