module MyCompany::MembersHelper
  def choice_for_role
    role_ids = member_has_role_ids
    roles = Role.find :all, :conditions=>["id in (?)", role_ids]
    roles.collect { |r| [r.name, r.id] }
  end # def choice_for_role

  def member_has_role_ids
    role_ids = [::Role::ROLE_ADMIN]
    if current_user.party.is_valid_agent?
      role_ids << ::Role::ROLE_AGENT
    end # if ...agent?
    if current_user.party.is_valid_publisher?
      role_ids << ::Role::ROLE_PUBLISHER
    end # if ...publisher?
    if current_user.party.is_valid_ad_owner?
      role_ids << ::Role::ROLE_AD_OWNER
      role_ids << ::Role::ROLE_SALES
    end # if ...ad_owner?
    role_ids
  end # def member_has_roles
end
