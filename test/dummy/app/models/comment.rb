class Comment < ApplicationRecord
  include ActiverecordActivityTracker::ActsAsTrackable

  acts_as_trackable([:create, :update])
end
