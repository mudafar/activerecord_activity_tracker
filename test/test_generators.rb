require 'test_helper'
require 'rails/generators/test_case'
require 'generators/activerecord_activity_tracker/install/install_generator'


class TestInstallGenerator < Rails::Generators::TestCase
  tests ActiverecordActivityTracker::Generators::InstallGenerator
  destination File.expand_path('../tmp', File.dirname(__FILE__))
  setup :prepare_destination

  # generate_sample_app
  # test 'test_install_generator' do
  #   assert_not_nil run_generator
  # end
end
