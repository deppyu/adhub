require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  test "share rate of agent" do
    contract = Factory.create :agent_contract
    assert_equal contract.share_rate_1, contract.party.agent_share_rate
  end

  test "share rate of agent, fall back to system default" do
    default_rate = SystemParameter.find_or_create(SystemParameter::AGENT_SHARE_RATE, SystemParameter::FLOAT_PARAM)
    default_rate.value = 0.02
    default_rate.save!
    contract = Factory.create :agent_contract, :share_rate_1=>nil
    assert_equal default_rate.value, contract.party.agent_share_rate

  end
end
