require 'test_helper'

class HourOverridesControllerTest < ActionController::TestCase
  setup do
    @hour_override = hour_overrides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hour_overrides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hour_override" do
    assert_difference('HourOverride.count') do
      post :create, hour_override: { hours_required: @hour_override.hours_required, reason: @hour_override.reason }
    end

    assert_redirected_to hour_override_path(assigns(:hour_override))
  end

  test "should show hour_override" do
    get :show, id: @hour_override
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hour_override
    assert_response :success
  end

  test "should update hour_override" do
    put :update, id: @hour_override, hour_override: { hours_required: @hour_override.hours_required, reason: @hour_override.reason }
    assert_redirected_to hour_override_path(assigns(:hour_override))
  end

  test "should destroy hour_override" do
    assert_difference('HourOverride.count', -1) do
      delete :destroy, id: @hour_override
    end

    assert_redirected_to hour_overrides_path
  end
end
