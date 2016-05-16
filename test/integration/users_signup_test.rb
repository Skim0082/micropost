require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {
            name: "user one",
            email: "user@valid.com",
            password: "password",
            password_confirmation: "password"
      }
    end
    assert_template 'users/show'
    assert is_logged_in?
    
    # Below are the exercises
    #assert_select 'div#<CSS id for error explanation>'
    #assert_select 'div.<CSS class for field with error>'
    #assert_not flash.nil?
  end
end
