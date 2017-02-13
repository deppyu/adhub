class Publisher::ReportsController < Publisher::PublisherController
  layout 'default'
  before_filter :find_date_range

  def summary
    sql = <<SQL
select ad_container_id, sum(request_count), sum(fulfill_count), sum(shown_count), sum(click_count), sum(income)
from publisher_daily_summaries
where party_id = #{current_user.party.id} and 
summary_date between '#{@begin_date}' and '#{@end_date}'
group by ad_container_id
SQL
    @rows = PublisherDailySummary.connection.select_rows sql
  end
  
  def daily
    ad_container_cause = ''
    if params[:ad_container_id] and !params[:ad_container_id].empty?
      @ad_container = current_user.party.ad_containers.where(:id=>params[:ad_container_id].to_i)
      ad_container_cause = " and ad_container_id = #{params[:ad_container_id]}"
    end
    sql = <<SQL
select summary_date, sum(request_count), sum(fulfill_count), sum(shown_count), sum(click_count), sum(income)
from publisher_daily_summaries
where party_id = #{current_user.party.id} and
summary_date between '#{@begin_date}' and '#{@end_date}' #{ad_container_cause}
order by summary_date
SQL
    @rows = PublisherDailySummary.connection.select_rows sql
  end

  private
  def find_date_range
    @begin_date = (parse_date(params[:begin_date]) || (Date.today - 7)).to_formatted_s(:db)
    @end_date = (parse_date(params[:end_date]) || (Date.today - 1)).to_formatted_s(:db)
  end

end
