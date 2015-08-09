require 'test_helper'

class WeekExceptionsControllerTest < ActionController::TestCase
  setup do
    @week_exception = week_exceptions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:week_exceptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create week_exception" do
    assert_difference('WeekException.count') do
      post :create, week_exception: { date: @week_exception.date, reason: @week_exception.reason, weight: @week_exception.weight }
    end

    assert_redirected_to week_exception_path(assigns(:week_exception))
  end

  test "should show week_exception" do
    get :show, id: @week_exception
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @week_exception
    assert_response :success
  end

  test "should update week_exception" do
    put :update, id: @week_exception, week_exception: { date: @week_exception.date, reason: @week_exception.reason, weight: @week_exception.weight }
    assert_redirected_to week_exception_path(assigns(:week_exception))
  end

  test "should destroy week_exception" do
    assert_difference('WeekException.count', -1) do
      delete :destroy, id: @week_exception
    end

    assert_redirected_to week_exceptions_path
  end
end
