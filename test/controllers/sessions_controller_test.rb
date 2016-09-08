require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:michael)
  	@other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
  	get users_path
  	assert_redirected_to login_path
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

end
