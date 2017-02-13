# -*- coding: utf-8 -*-
class AdDailySummary < ActiveRecord::Base
  def self.summary_for(begin_date, end_date)
    self.connection.execute "insert into ad_daily_summaries(party_id, campaign_id, publish_policy_id, advertisement_id, impression_count, summary_date) (select ad_owner_id, campaign_id, publish_policy_id, advertisement_id, count(*), request_date from ad_requests where advertisement_id is not null and shown = 1 and request_date between '#{begin_date}' and '#{end_date}' group by ad_owner_id, campaign_id, publish_policy_id, advertisement_id, request_date)"
    self.connection.execute 'update ad_daily_summaries s set click_count = (select count(*) from ad_requests r where request_date = s.summary_date and r.advertisement_id = s.advertisement_id and clicked = 1)'
    self.connection.execute 'update ad_daily_summaries s set used_budget = (select sum(unit_price) from ad_requests r where request_date = s.summary_date and r.advertisement_id = s.advertisement_id and paid = 1)'
  end

  def self.create_transaction_for_ad_owner(begin_date, end_date)
    self.connection.execute "insert into account_transactions(account_id, operation, op_way, amount, note, created_at) (select accounts.id, 1, 1, sum(used_budget), concat(date_format(summary_date, '%Y年%m月%d日'), '广告费支出'), current_timestamp() from ad_daily_summaries inner join accounts on ad_daily_summaries.party_id = accounts.party_id where summary_date between '#{begin_date}' and '#{end_date}' group by accounts.id, summary_date)"
  end
end
