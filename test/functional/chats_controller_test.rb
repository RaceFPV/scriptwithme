require 'test_helper'

class ChatsControllerTest < ActionController::TestCase
  test "should get room" do
    get :room
    assert_response :success
  end

end
