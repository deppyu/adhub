class AdOwner::ReportsController < AdOwner::AdOwnerController
  before_filter :find_date_range

  SCOPE_TO_GROUP_BY = { 'campaign' => 'ad_group_id', 'ad_group' => 'advertisement_id' }
  def summary
    @scope_obj = find_scope_obj
    @group_by = find_group_by
    @group_by_class = find_group_by_class(@group_by)
    scope_cause = ''
    if params[:scope_class]
      scope_cause = "and #{params[:scope_class]}_id = #{params[:scope_id]}"
    end
    sql = <<SQL
select sum(impression_count), sum(click_count), sum(used_budget)
from ad_daily_summaries
where summary_date between '#{@begin_date}' and '#{@end_date}' and party_id = #{catch_ad_owner.id} #{scope_cause}

SQL
    @rows = AdDailySummary.connection.select_rows sql
  end

  def daily
    @scope_obj = find_scope_obj
    logger.info "@scope_obj is #{@scope_obj}"
    scope_cause = ''
    if @scope_obj
      scope_cause = "and #{params[:scope_class]}_id = #{params[:scope_id]}"
    end

    sql = <<SQL
select summary_date, sum(impression_count), sum(click_count), sum(used_budget)
from ad_daily_summaries
where summary_date between '#{@begin_date}' and '#{@end_date}' #{scope_cause}
group by summary_date
order by summary_date
SQL
    @rows = AdDailySummary.connection.select_rows sql
  end
  
  private
  def find_group_by
    g = SCOPE_TO_GROUP_BY[params[:scope_class]]
    g || 'campaign_id'
  end

  def find_group_by_class(group_by)
    group_by =~ /(.*)_id$/
    @group_by_class = class_for_name $1
  end

  def find_scope_obj
    return nil if params[:scope_class].nil? or params[:scope_class].empty? or params[:scope_id].nil? or params[:scope_id].empty?
    class_for_name(params[:scope_class]).find params[:scope_id]
  end

  def find_date_range
    @begin_date = (parse_date(params[:begin_date]) || (Date.today - 7)).to_formatted_s(:db)
    @end_date = (parse_date(params[:end_date]) || (Date.today - 1)).to_formatted_s(:db)
  end
end
