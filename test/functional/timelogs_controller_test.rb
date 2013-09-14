require 'test_helper'

class TimelogsControllerTest < ActionController::TestCase
  setup do
    @timelog = timelogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timelogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timelog" do
    assert_difference('Timelog.count') do
      post :create, timelog: { timein: @timelog.timein, timeout_timestamp: @timelog.timeout_timestamp }
    end

    assert_redirected_to timelog_path(assigns(:timelog))
  end

  test "should show timelog" do
    get :show, id: @timelog
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timelog
    assert_response :success
  end

  test "should update timelog" do
    put :update, id: @timelog, timelog: { timein: @timelog.timein, timeout_timestamp: @timelog.timeout_timestamp }
    assert_redirected_to timelog_path(assigns(:timelog))
  end

  test "should destroy timelog" do
    assert_difference('Timelog.count', -1) do
      delete :destroy, id: @timelog
    end

    assert_redirected_to timelogs_path
  end
end
