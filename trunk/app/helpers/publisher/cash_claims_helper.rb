module Publisher::CashClaimsHelper
  def cash_claim_result(claim)
    claim = claim.is_a?(CashClaim) ? claim.result : claim
    t "cash_claim.result.#{claim}"
  end
end
