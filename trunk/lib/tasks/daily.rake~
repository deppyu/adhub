namespace :period do

  task :ad_daily_summary => :environment do
    begin_date = AdDailySummary.maximum(:summary_date) || AdRequest.minimum(:request_date)
    unless begin_date.nil?
      begin_date = begin_date + 1
      end_date = Date.today - 1
      unless end_date < begin_date
        AdDailySummary.transaction do
          AdDailySummary.summary_for begin_date, end_date
        end
      end
    end
  end

  task :publisher_daily_summary => :environment do
    begin_date = PublisherDailySummary.maximum(:summary_date) || AdRequest.minimum(:request_date)
    unless begin_date.nil?
      begin_date = begin_date + 1
      end_date = Date.today - 1
      unless end_date < begin_date
        PublisherDailySummary.transaction do
          PublisherDailySummary.summary_for begin_date, end_date
        end
      end
    end    
  end

  task :ad_owner_daily_tran => :environment do
    sys_param = SystemParameter.find_or_create('ad_owner_daily_tran_to', SystemParameter::DATE_PARAM)
    begin_date = sys_param.value
    if begin_date.nil?
      begin_date = AdRequest.minimum(:request_date)
    else
      begin_date = begin_date + 1
    end
    end_date = Date.today - 1
    unless begin_date.nil? or end_date < begin_date
      AdDailySummary.transaction do 
        AdDailySummary.create_transaction_for_ad_owner begin_date, end_date
        sys_param.value = end_date
        sys_param.save!
      end
    end
  end

  task :publisher_daily_tran => :environment do
    sys_param = SystemParameter.find_or_create('publisher_daily_tran_to', SystemParameter::DATE_PARAM)
    begin_date = sys_param.value
    if begin_date.nil?
      begin_date = AdRequest.minimum(:request_date)
    else
      begin_date = begin_date + 1
    end
    end_date = Date.today - 1
    unless begin_date.nil? or end_date < begin_date
      PublisherDailySummary.transaction do 
        PublisherDailySummary.create_transaction_for_publisher begin_date, end_date
        sys_param.value = end_date
        sys_param.save!
      end
    end
  end

  # task :clear_creating_ad_group => :environment do
  #    AdGroup.connection.execute "delete from ad_groups where creating = 1 and created_at <= '#{(Time.now - 1.day).to_formatted_s(:db) }'"
  # end

  task :daily => [:ad_daily_summary, :publisher_daily_summary, :ad_owner_daily_tran, :publisher_daily_tran] do
  end
end
