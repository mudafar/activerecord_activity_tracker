require 'test_helper'

class TestActsAsTrackable < ActiveSupport::TestCase
  include ActiverecordActivityTracker::Owner

  def setup
    set_owner(Post.create(title: 'test_post_title'))
    @comment = Comment.new(title: 'test_title', body: 'test_body')
    @comment.save
  end


  test 'comment_create_activity' do
    assert_not_nil @comment.ar_activities.find_by_key('comment.create')
  end

  test 'comment_update_activity' do
    @comment.update(title: 'title_modified')
    assert_not_nil @comment.ar_activities.find_by_key('comment.update')

    @comment.update(title: 'title_modified')
    assert_equal @comment.ar_activities.where(key: 'comment.update').count, 2
  end


  test 'create_activity_with_default_params' do
    @comment.create_ar_activity
    assert_equal @comment.ar_activities.where(key: 'comment.create').count, 1
  end

  test 'create_activity_with_custom_key' do
    @comment.create_ar_activity(key: 'custom_key')
    assert_not_nil @comment.ar_activities.find_by_key('custom_key')
  end

  test 'create_activity_with_custom_owner' do
    @comment.create_ar_activity(owner: @comment)
    assert_not_nil @comment.ar_activities.find_by_owner_id(@comment.id)
  end

  test 'create_activity_with_data' do
    @comment.create_ar_activity(data: 'data_text')
    assert_not_nil @comment.ar_activities.find_by_data('data_text')
  end

  test 'create_activity_with_data_duplication' do
    @comment.create_ar_activity!(data: 'data_text')
    @comment.create_ar_activity!(data: 'data_text')
    assert_equal @comment.ar_activities.where(data: 'data_text').count, 2
  end

  test 'create_activity_with_owner_duplication' do
    post = Post.create(title: 'new_post')
    @comment.create_ar_activity!(owner: post)
    @comment.create_ar_activity!(owner: post)
    assert_equal @comment.ar_activities.where(owner_id: post.id).count, 2
  end

  test 'create_activity_with_key_duplication' do
    @comment.create_ar_activity!(key: 'same_key')
    @comment.create_ar_activity!(key: 'same_key')
    assert_equal @comment.ar_activities.where(key: 'same_key').count, 2
  end

end