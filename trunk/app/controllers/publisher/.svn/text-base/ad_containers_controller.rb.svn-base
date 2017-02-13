#_*_ coding : utf-8_*_
require 'dynamic_query'
class Publisher::AdContainersController < Publisher::PublisherController
  include Imon::DynamicQuery
  layout 'default'
  before_filter :find_ad_container, :only=>[:submission, :edit, :show, :update]

  def index
    exps = expressions_from_params params, AdContainer
    exps << self.equal(:party_id, current_user.party.id)
    @ad_containers = AdContainer.paginate :all, :conditions=>self.and(exps).conditions, :order=>'created_at desc', :page=>params[:page], :per_page=>10
  end
  
  def create
    @ad_container = AdContainer.new params[:ad_container]
    @ad_container.party_id = current_user.party.id
    @ad_container.status = Application::STATUS_EDITING
    unless @ad_container.save
      flash.now[:notice] = '保存失败!'
      render :new, :layout=>'default'
      return
    else
      if params[:content_categories]
          ids = params[:content_categories].keys
          @ad_container.content_categories.clear
          ids.each do |element|
             content_category = ContentCategory.find element.to_i
             @ad_container.content_categories << content_category
          end                 
      end
      flash[:notice] = '保存成功!'
      redirect_to :action=>:show,:id=>@ad_container.id ,:format=>:html
    end
  end
  
  def update
     unless @ad_container.update_attributes params[:ad_container]
       flash.now[:notice] = '编辑失败!'
       render :action=>:edit
     else
        @ad_container.status = AdContainer::STATUS_EDITING
        @ad_container.save!
       if params[:content_categories]
          ids = params[:content_categories].keys
          @ad_container.content_categories.clear
          ids.each do |element|
             content_category = ContentCategory.find element.to_i
             @ad_container.content_categories << content_category
          end             
      end
      flash[:notice] = "编辑成功！"
      redirect_to publisher_ad_container_path(@ad_container, :format=>:html)
     end
  end
  
  def submission
    unless @ad_container.update_attribute(:status, AdContainer::STATUS_DISAPPROVED)
      alert '未提交成功'
    end
  end

protected
  def expression_for_name(name)
      self.like :name, name
  end
private
  def find_ad_container
      @ad_container = AdContainer.find params[:id]
  end


end
