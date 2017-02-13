require 'dynamic_query' 

class Admin::AdvertisementsController < Admin::AdminController
  include Imon::DynamicQuery

  before_filter :find_advertisement, :except=>[:index]

  def index
    exps = expressions_from_params params, Advertisement
    @advertisements = Advertisement.paginate :conditions=>self.and(exps).conditions, :page=>params[:page], :per_page=>20
  end

  def approve
    begin
      if @advertisement.waiting_approve?
        Advertisement.transaction do  
          approve_log = ApproveLog.new :member=>current_user, :result=>params[:approve_result], :opinion=>params[:approve_opinion],
          :target=>@advertisement
          approve_log.save!
          @advertisement.approve! approve_log.result
        end
      end
      redirect_to admin_advertisement_path(@advertisement, :format=>:html)
    rescue ActiveRecord::RecordInvalid
      render :action=>:show
    end
  end
  

  
  def expression_for_party(party_name)
    sql = <<SQL
   ad_group_id in (select ag.id from 
    (ad_groups ag inner join campaigns c on ag.campaign_id = c.id ) 
    inner join parties p on c.party_id = p.id 
    where  p.name like '%%#{party_name}%%')
SQL
     logger.info "sql is #{sql}"
    self.raw(sql)
  end

  def expression_for_status(status)
      self.equal(:status,status)
  end
  
  private  
  def find_advertisement
    @advertisement = Advertisement.find params[:id]
    # @ad_group = @advertisement.ad_group
  end
end
