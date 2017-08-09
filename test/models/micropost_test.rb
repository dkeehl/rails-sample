require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:thomas)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
    
  test 'content should be present' do
    @micropost.content = '    '
    assert_not @micropost.valid?
  end

  test 'content should be less than 140 characters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'new posts should display first' do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
