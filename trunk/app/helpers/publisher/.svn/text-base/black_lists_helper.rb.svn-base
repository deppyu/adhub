module Publisher::BlackListsHelper
  def choice_for_black_member_type
    options_tags = []
    options_tags << [(Party.human_name), "Party"]
    options_tags << [(Advertisement.human_name), "Advertisement"]
  end

  def get_black_member_type_name(type)
    if type == "Party"
      return Party.human_name
    end # if type=="Party"
    if type == "Advertisement"
      return Advertisement.human_name
    end
  end # def get_black_member_type_name(type)
end
