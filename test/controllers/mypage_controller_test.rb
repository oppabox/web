require 'test_helper'

class MypageControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get carry" do
    get :carry
    assert_response :success
  end

end
