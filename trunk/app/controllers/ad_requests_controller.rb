require 'dynamic_query'

class AdRequestsController < ApplicationController
  include Imon::DynamicQuery
  skip_before_filter :verify_authenticity_token

  def index
    ad_container = AdContainer.find_by_identity params[:app]
    logger.info "found container #{ad_container}"
    unless ad_container.active? and ad_container.party.is_valid_publisher?
      render :json=>{}, :status=>400
      return
    end

    last_req = AdRequest.where(:ad_container_id=>ad_container.id, :ip_address=>request.env['REMOTE_ADDR'], :size_code=>params[:size]).order('created_at desc').first
    logger.info "last req at #{last_req.created_at.to_i}, and 5 seconds before is #{(Time.now - 5.second).to_i}" if last_req

    if last_req and last_req.created_at.to_i > (Time.now - 5.second).to_i
      render :json=>{}, :status=>400
      return
    end
    size = params[:size]
    ad_request = AdRequest.create! :publisher=>ad_container.party, :ad_container => ad_container, :ip_address=>request.env['REMOTE_ADDR'], :size_code=>size
    show_control = find_advertisement ad_container
    ad_request.show_control = show_control
    ad_request.save!
    puts "ad_reqeust.fulfilled is #{ad_request.fulfilled}"
    if show_control
      advertisement = show_control.advertisement
      # publish_policy = show_control.publish_policy
      # ad_request.to_show_publish_policy = publish_policy
      # ad_request.fulfilled = true
      # ad_request.unit_price = show_control.unit_price
      # ad_request.save
      logger.info "advertisement = #{advertisement}"
      render :json=>{ :ad_request_id=>ad_request.id, 
        :advertisement=>advertisement.ad_format.json_for_ad(advertisement, size).merge({:id=>advertisement.id}),
        :call_to_action=>({:url=>advertisement.content_url}).merge({:type=>show_control.publish_policy.call_to_action.name})}
    else
      render :json=>{}
    end
  end

  def shown
    ad_request = AdRequest.find params[:id]
    unless ad_request.shown
      ad_request.transaction do 
        ad_request.shown!
      end
    end
    render :json=>{}
  end

  def clicked
    ad_request = AdRequest.find params[:id]
    unless ad_request.clicked
      ad_request.transaction do 
        ad_request.clicked!
      end
    end
    render :json=>{}    
  end

  private
  def find_advertisement(ad_container)
    today = Date.today
    exps = [ self.less_or_equal(:begin, today), self.or(self.is_null(:end), self.greater_or_equal(:end, today))]
    ad_formats = AdFormat.formats_for_device params[:device]
    ad_formats = ad_formats.collect { |f| "'#{f.name}'" }
    exps << self.in(:ad_format, ad_formats)
    exps << self.equal(:channel_id, ad_container.channel_id)
    exps << self.or(self.is_null(:size_codes), self.like(:size_codes, "'#{params[:size]}'"))
    if params[:last_ad] 
      exps << self.not(self.equal(:advertisement_id, params[:last_ad].to_i))
    end
    if ad_container.content_categories.empty?
      exps << self.is_null(:content_categories)
    else
      or_exps = [self.is_null(:content_categories)]
      ad_container.content_category_ids.each do |cat_id|
        or_exps << self.like(:content_categories, "'#{cat_id}'")
      end
      exps << self.or(or_exps)
    end
    exps << self.or( self.is_null(:ad_containers), 
                     self.like(:ad_containers, "'#{ad_container.id}'"))

    finding = true
    exclude_ids = []
    while finding
      unless exclude_ids.empty?
        conditions= self.and(self.and(exps), self.not(self.in(:id, exclude_ids))).conditions
      else
        conditions= self.and(exps).conditions
      end
      show_control = AdShowControl.find :first, :conditions=>conditions, :order=>'weight * rand() desc'
      return nil unless show_control
      return show_control if show_control.check_daily_budget and show_control.check_balance
      exclude_ids << show_control.id
    end
  end
end
