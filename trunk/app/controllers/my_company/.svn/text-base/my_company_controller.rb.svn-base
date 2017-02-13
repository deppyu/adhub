class MyCompany::MyCompanyController < ApplicationController
  before_filter :authenticated
  select_main_menu 'mnu_my_company'
  before_filter :party_is_null?
  before_filter :find_party

  private
  def find_party
    @party = current_user.party
  end
end
