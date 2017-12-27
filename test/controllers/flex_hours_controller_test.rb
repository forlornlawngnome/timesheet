require 'test_helper'

class FlexHoursControllerTest < ActionController::TestCase
  setup do
    @flex_hour = flex_hours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flex_hours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flex_hour" do
    assert_difference('FlexHour.count') do
      post :create, flex_hour: { num_minutes: @flex_hour.num_minutes, reason: @flex_hour.reason, user_id: @flex_hour.user_id, week_id: @flex_hour.week_id }
    end

    assert_redirected_to flex_hour_path(assigns(:flex_hour))
  end

  test "should show flex_hour" do
    get :show, id: @flex_hour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @flex_hour
    assert_response :success
  end

  test "should update flex_hour" do
    patch :update, id: @flex_hour, flex_hour: { num_minutes: @flex_hour.num_minutes, reason: @flex_hour.reason, user_id: @flex_hour.user_id, week_id: @flex_hour.week_id }
    assert_redirected_to flex_hour_path(assigns(:flex_hour))
  end

  test "should destroy flex_hour" do
    assert_difference('FlexHour.count', -1) do
      delete :destroy, id: @flex_hour
    end

    assert_redirected_to flex_hours_path
  end
end
