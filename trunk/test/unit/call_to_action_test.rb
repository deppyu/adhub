require 'test_helper'

require 'call_to_action'

class CallToActionTest < ActiveSupport::TestCase
  def setup
    @backup = CallToAction.actions
    CallToAction.actions = []
  end

  def teardown
    CallToAction.actions = @backup
  end

  test "add one action, no block" do
    CallToAction.add 'test', 'note'
    assert_equal 1, CallToAction.actions.size
  end
  
  test "add one action, initialized parameters" do
    action = CallToAction.add 'test', 'note'
    assert_equal 'test', action.name
    assert_equal 'note', action.note
  end

  test "add one action, with config block, add param in block" do
    action = CallToAction.add 'test', 'note' do |action|
      action.add_param 'param1', 'param note', :type=>'url'
    end
    assert_equal 1, action.params.size
    param = action.params[0]
    assert_equal 'param1', param.name
    assert_equal 'param note', param.note
    assert_equal 1, param.options.size
    assert_equal 'url', param.options[:type]
  end
end
