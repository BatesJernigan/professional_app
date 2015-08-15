require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bates)
  end

  test "layout links as logged out user" do
    get root_path
    assert_template 'static_pages/home'
    assert_select("a[href=?]", root_path, count: 2)
    assert_select("a[href=?]", help_path)
    assert_select("a[href=?]", about_path)
    assert_select("a[href=?]", contact_path)
    assert_select('a[href=?]', login_path)
    assert_select('a[href=?]', user_path(@user.id), count: 0)
    assert_select('a[href=?]', edit_user_path(@user.id), count: 0)
    assert_select('a[href=?]', logout_path, count: 0)
  end

  test "layout links as signed in user" do
    log_in_as(@user)
    get root_path
    assert_template('static_pages/home')
    assert_select("a[href=?]", root_path, count: 2)
    assert_select("a[href=?]", help_path)
    assert_select("a[href=?]", about_path)
    assert_select("a[href=?]", contact_path)
    assert_select('a[href=?]', user_path(@user.id))
    assert_select('a[href=?]', edit_user_path(@user.id))
    assert_select('a[href=?]', logout_path)
    assert_select('a[href=?]', login_path, count: 0)
  end
end
