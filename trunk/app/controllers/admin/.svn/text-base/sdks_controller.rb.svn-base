class Admin::SdksController < Admin::AdminController
  before_filter :find_sdk,:only=>[:show,:edit,:update,:upload_sdk,:destroy]
  
  def index
      @sdks = Sdk.paginate :all,:order=>'name',:page => params[:page], :per_page =>15 
  end
  
  def new
    @sdk = Sdk.new
  end
  
  def create
    @sdk = Sdk.new params[:sdk]
    @sdk.status = Sdk::UNUPLOAD_STATUS
    
    unless @sdk.save
      flash.now[:notice] = '保存不成功！'
      render :action=>:new
    else
      render :action=>:next_step,:id=>@sdk.id
    end
  end
  
  def next_step
     
  end
  
  def edit
  
  end
  
  def upload_sdk
    unless @sdk.update_attributes (:file=>params[:resource_file],
                                       :status=>Sdk::UPLOADED_STATUS)                                       
      render :json=>{:message=>'上传不成功！'}
    else
      render :json=>{:message=>'上传成功！'}
    end
  end
  
  def update
    unless @sdk.update_attributes params[:sdk]
      flash.now[:notice] = '编辑不成功！'
      render :action=>:edit
    else
      flash[:notice] ='编辑成功！'
      redirect_to :action=>:index
    end
  end
  
  def destroy
      unless @sdk.destroy
           alert '删除不成功！'
      else
           render :update do |page|
               page.remove element_id @sdk
           end    
      end
  end
  
  private
  def find_sdk
    @sdk = Sdk.find params[:id]
  end
end