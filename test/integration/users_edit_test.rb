require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bates)
    @other_user = users(:archer)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get(edit_user_path(@user))
    assert_template('users/edit')
    patch(user_path,
      user: {name: '', email: 'foo@bar', password: 'bad', password_confirmation: 'password'})
    assert_template('users/edit')
  end

  test 'successful edit with friendly forwarding' do
    get(edit_user_path(@user))
    log_in_as(@user)
    assert_redirected_to(edit_user_path(@user))
    assert(session[:forwarding_url].nil?)
    get(edit_user_path(@user))
    assert_template('users/edit')
    patch(user_path, user: { name: 'Foo Bar', email: 'foo@bar.com', password: '', password_confirmation: '' })
    assert_not(flash.empty?)
    assert_redirected_to(@user)
    @user.reload
    assert_equal('Foo Bar', @user.name)
    assert_equal('foo@bar.com', @user.email)
  end
end
