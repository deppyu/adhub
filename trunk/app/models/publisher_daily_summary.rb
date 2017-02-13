# -*- coding: utf-8 -*-
class PublisherDailySummary < ActiveRecord::Base
  belongs_to :member_id
  belongs_to :ad_container_id

  def self.summary_for(begin_date, end_date)
    self.connection.execute "insert into publisher_daily_summaries(party_id, ad_container_id, request_count, summary_date) (select publisher_id, ad_container_id, count(*), request_date from ad_requests where request_date between '#{begin_date}' and '#{end_date}' group by publisher_id, ad_container_id, request_date)"
    self.connection.execute "update publisher_daily_summaries p set fulfill_count = (select count(*) from ad_requests r where r.request_date = p.summary_date and r.ad_container_id = p.ad_container_id and fulfilled = 1)"
    self.connection.execute "update publisher_daily_summaries p set shown_count = (select count(*) from ad_requests r where r.request_date = p.summary_date and r.ad_container_id = p.ad_container_id and shown = 1)"
    self.connection.execute "update publisher_daily_summaries p set click_count = (select count(*) from ad_requests r where r.request_date = p.summary_date and r.ad_container_id = p.ad_container_id and clicked = 1)"
    self.connection.execute "update publisher_daily_summaries p set income = (select sum(unit_price) from ad_requests r where r.request_date = p.summary_date and r.ad_container_id = p.ad_container_id and paid = 1)"
  end

  def self.create_transaction_for_publisher(begin_date, end_date)
    self.connection.execute "insert into account_transactions(account_id, operation, op_way, amount, note, created_at) (select a.id, 0, 2, sum(income), concat(date_format(summary_date, '%Y年%m月%d日'), '广告费收入'), current_timestamp() from publisher_daily_summaries s inner join accounts a on s.party_id = a.party_id where summary_date between '#{begin_date}' and '#{end_date}' group by a.id, summary_date)"
  end

end
