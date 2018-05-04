module ActiverecordActivityTracker
  module CurrentOwner
    thread_mattr_accessor :owner
  end
end

