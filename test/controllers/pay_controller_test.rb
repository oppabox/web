require 'test_helper'

class PayControllerTest < ActionController::TestCase
  test "should get billing" do
    get :billing
    assert_response :success
  end

  test "should get success" do
    get :success
    assert_response :success
  end

end
