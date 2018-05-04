require 'rails/generators/named_base'

module ActiverecordActivityTracker
  # A generator module with Activity table schema.
  module Generators
    # A base module
    module Base
      # Get path for migration template
      def source_root
        @_activerecord_activity_tracker_source_root ||= File.expand_path(File.join('../activerecord_activity_tracker', generator_name, 'templates'), __FILE__)
      end
    end
  end
end