require 'activerecord_activity_tracker/current_owner'

module ActiverecordActivityTracker
  module Owner

    def get_owner
      ActiverecordActivityTracker::CurrentOwner.owner
    end

    def set_owner(owner)
      ActiverecordActivityTracker::CurrentOwner.owner = owner
    end

    def clear_owner
      ActiverecordActivityTracker::CurrentOwner.owner = nil
    end

  end
end