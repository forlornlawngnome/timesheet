require 'test_helper'

class RequirementsControllerTest < ActionController::TestCase
  setup do
    @requirement = requirements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:requirements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create requirement" do
    assert_difference('Requirement.count') do
      post :create, requirement: { build_meetings: @requirement.build_meetings, freshman_hours: @requirement.freshman_hours, junior_hours: @requirement.junior_hours, leadership_hours: @requirement.leadership_hours, pre_hours: @requirement.pre_hours, pre_meetings: @requirement.pre_meetings, senior_hours: @requirement.senior_hours, sophomore_hours: @requirement.sophomore_hours }
    end

    assert_redirected_to requirement_path(assigns(:requirement))
  end

  test "should show requirement" do
    get :show, id: @requirement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @requirement
    assert_response :success
  end

  test "should update requirement" do
    patch :update, id: @requirement, requirement: { build_meetings: @requirement.build_meetings, freshman_hours: @requirement.freshman_hours, junior_hours: @requirement.junior_hours, leadership_hours: @requirement.leadership_hours, pre_hours: @requirement.pre_hours, pre_meetings: @requirement.pre_meetings, senior_hours: @requirement.senior_hours, sophomore_hours: @requirement.sophomore_hours }
    assert_redirected_to requirement_path(assigns(:requirement))
  end

  test "should destroy requirement" do
    assert_difference('Requirement.count', -1) do
      delete :destroy, id: @requirement
    end

    assert_redirected_to requirements_path
  end
end
