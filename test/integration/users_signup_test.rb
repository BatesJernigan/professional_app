require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "", email: "user@invalid",
        password: "foo", password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test 'valid signup information with account activation' do
    get(signup_path)
    assert_difference 'User.count', 1 do
      post(users_path, user: { name: 'example user', email: "user@example.com",
        password: "samplePhrase", password_confirmation: "samplePhrase" })
    end
    assert_equal(1, ActionMailer::Base.deliveries.size)
    user = assigns(:user)
    assert_not(user.activated?)
    
    # Try to Log in before activation
    log_in_as(user)
    assert_not(is_logged_in?)
    
    # Invalid Activation Token
    get(edit_account_activation_path('invalid token'))
    assert_not(is_logged_in?)
    # Vaid Activation Token, invalid email
    get(edit_account_activation_path(user.activation_token, email: 'wrong'))
    assert_not(is_logged_in?)

    # Valid activation token and email
    get(edit_account_activation_path(user.activation_token, email: user.email))
    assert(user.reload.activated?)
    follow_redirect!
    assert_template('users/show')
    assert(is_logged_in?)
  end
end
