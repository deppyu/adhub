module AdOwner::PublishPolicies
  def publsh_policy_status(pp)
    status = pp.is_a?(PublishPolicy) ? pp.status : pp.to_s.to_i
    t "publish_policy.status.#{status}"
  end
end