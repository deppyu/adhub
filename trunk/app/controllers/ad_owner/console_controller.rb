class AdOwner::ConsoleController < AdOwner::AdOwnerController
  def index  
    if params[:p_id]
      party = Party.find params[:p_id]
      session[:party] = party
    end
    
      respond_to do |format|
        format.html
        format.mobile { render :layout=>'mobile' }
      end
  end
  
  def select_ad_owner
    @ad_owners = current_user.delegated_ad_owners.paginate :order=>'name',:page=>params[:page],:per_page=>10
  end
end
