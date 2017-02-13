class SitesController < ApplicationController
  layout 'default'

  def index
    respond_to do |format|
      format.mobile { 
        if authenticated?
          redirect_to '/ad_owner'
        else
          redirect_to '/session/new.mobile'           
        end
      }

      format.html {
        if authenticated?
          redirect_to '/members/my_account'
        end
      }
    end
  end
end
