class Publisher::PublisherController < ApplicationController
  before_filter :authenticated
  select_main_menu 'mnu_publisher'
  before_filter :party_is_null?
  before_filter :is_publisher?

  def is_publisher?
    unless current_user.party and current_user.party.is_valid_publisher?
      redirect_to '/'
    end
  end
end
