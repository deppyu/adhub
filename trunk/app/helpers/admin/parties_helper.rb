module Admin::PartiesHelper
  def choice_for_party_type
    Party::ALL_PARTY_TYPE.collect{|t|[party_type_for_fetch(t),t]}
  end

  def party_type_for_fetch(party_type)
    t "party.party_type.#{party_type}"
  end

  def choice_for_contract_business_type
    Contract::ALL_BUSINESS_TYPE.collect{|t|[business_type_for_fetch(t),t]}
  end

  def business_type_for_fetch(business_type)
    t "contract.business_type.#{business_type}"
  end
end
