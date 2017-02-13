namespace :period do
  task :destroy_unused_ad_resources => :environment do
    AdResource.clear_unused!
  end

  task :hourly => :destroy_unused_ad_resources 
end
