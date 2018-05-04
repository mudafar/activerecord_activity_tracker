require 'test_helper'
require 'test_acts_as_trackable'
require 'test_generators'

class ActiverecordActivityTracker::Test < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, ActiverecordActivityTracker
  end
end
