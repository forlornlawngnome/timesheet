require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get hours" do
    get :hours
    assert_response :success
  end

end
