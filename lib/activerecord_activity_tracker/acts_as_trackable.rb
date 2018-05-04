# require 'activerecord_activity_tracker/activerecord_activity'
require 'activerecord_activity_tracker/owner'

module ActiverecordActivityTracker
  module ActsAsTrackable
    extend ActiveSupport::Concern
    include ActiverecordActivityTracker::Owner

    class_methods do
      def acts_as_trackable(tracked = [:create, :update])
        if tracked.include?(:create)
          before_create -> {ar_activities.build(owner: get_owner, key: "#{model_name.param_key}.create")}
        end

        if tracked.include?(:update)
          before_update -> {ar_activities.build(owner: get_owner, key: "#{model_name.param_key}.update")}
        end
      end
    end


    included do
      has_many :ar_activities, as: :trackable, dependent: :destroy

      # Prevent duplication by default
      def create_ar_activity(options = {})
        _create_ar_activity(false, options)
      end

      # Allow duplication
      def create_ar_activity!(options = {})
        _create_ar_activity(true, options)
      end

    end


    private

    def _create_ar_activity(allow_dup, options = {})
      default_options = {
          key: "#{model_name.param_key}.create",
          data: nil,
          owner: get_owner
      }
      default_options.merge!(options)


      if allow_dup ||
          (!ar_activities.exists?(key: default_options[:key]) ||
              !ar_activities.exists?(owner: default_options[:owner]) ||
              !ar_activities.exists?(data: default_options[:data])
          )
        ar_activities.create(default_options)
      end
    end

  end
end