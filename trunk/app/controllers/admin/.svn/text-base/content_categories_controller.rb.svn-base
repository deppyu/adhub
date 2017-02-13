class Admin::ContentCategoriesController < Admin::AdminController
   
   
   def index
      @content_categories = ContentCategory.paginate :all,:order=>'name',:page=>params[:page],:per_page =>10
   end
   
   def new
     @content_category = ContentCategory.new
   end
   
   def create
     @content_category = ContentCategory.new params[:content_category]
     unless @content_category.save
          flash.now[:notice] = '新建不成功！'
     else
           flash[:notice] = '新建成功!'
           redirect_to :action =>:index     
     end
   end
   
   def edit
     @content_category = ContentCategory.find params[:id]   
   end
   
   def update
     @content_category = ContentCategory.find params[:id]
     unless @content_category.update_attributes params[:content_category]
              flash.now[:notice] = '编辑不成功!'
     else
                flash[:notice] = '编辑成功！'
                redirect_to :action=>:index
     end
  end
  
  def destroy
   @content_category = ContentCategory.find params[:id]
   unless @content_category.destroy
     alert '删除失败！'
   else
     render :update do |page|
       page.remove element_id @content_category
     end
   end
  end
end