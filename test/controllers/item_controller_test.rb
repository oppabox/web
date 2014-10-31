require 'test_helper'

class ItemControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

end
