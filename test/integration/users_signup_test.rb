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
  end
end
