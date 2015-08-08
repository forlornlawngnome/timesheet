require 'test_helper'

class YearsControllerTest < ActionController::TestCase
  setup do
    @year = years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create year" do
    assert_difference('Year.count') do
      post :create, year: { build_season_start: @year.build_season_start, year_end: @year.year_end, year_start: @year.year_start }
    end

    assert_redirected_to year_path(assigns(:year))
  end

  test "should show year" do
    get :show, id: @year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @year
    assert_response :success
  end

  test "should update year" do
    put :update, id: @year, year: { build_season_start: @year.build_season_start, year_end: @year.year_end, year_start: @year.year_start }
    assert_redirected_to year_path(assigns(:year))
  end

  test "should destroy year" do
    assert_difference('Year.count', -1) do
      delete :destroy, id: @year
    end

    assert_redirected_to years_path
  end
end
