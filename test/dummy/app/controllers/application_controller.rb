class ApplicationController < ActionController::Base
  include ActiverecordActivityTracker::Owner

  protect_from_forgery with: :exception

  around_action :set_ar_activity_owner


  private

  def set_ar_activity_owner
    set_owner Post.create(title: 'test')
    yield
  ensure
    clear_owner
  end


end
