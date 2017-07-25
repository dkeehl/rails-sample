require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @activated_user = users(:thomas)
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                        email: 'user@invalid',
                                        password: 'foo',
                                        password_comfirmation: 'foo' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'form[action="/signup"]'
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_comfirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # try to log in before activation
    log_in_as user
    assert_not is_logged_in?
    # invalid activation token
    get edit_account_activation_url('invalid token', email: user.email)
    assert_not is_logged_in?
    # invalid email
    get edit_account_activation_url(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # should not show user profile when not activated
    get user_path(user)
    assert_redirected_to root_url
    # should not shown in the users page when not activated
    log_in_as @activated_user
    get users_path
    #assert_nil assigns(:users).find_by(id: user.id)
    delete logout_path
    # valid activation token
    get edit_account_activation_url(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    get users_path
    assert_not_nil assigns(:users).find_by(id: user.id)
  end

end
