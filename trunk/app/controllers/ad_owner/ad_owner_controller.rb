class AdOwner::AdOwnerController < ApplicationController
  layout 'default'
  select_main_menu 'mnu_ad_owner'

  before_filter :authenticated
  
  def catch_ad_owner
      if session[:party] != nil && session[:party].is_a?(Party)
         return session[:party]
      else
         return current_user.party
      end
  end
end
