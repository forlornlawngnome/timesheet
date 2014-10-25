require 'test_helper'

class FormsUsersControllerTest < ActionController::TestCase
  setup do
    @forms_user = forms_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forms_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forms_user" do
    assert_difference('FormsUser.count') do
      post :create, forms_user: {  }
    end

    assert_redirected_to forms_user_path(assigns(:forms_user))
  end

  test "should show forms_user" do
    get :show, id: @forms_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forms_user
    assert_response :success
  end

  test "should update forms_user" do
    put :update, id: @forms_user, forms_user: {  }
    assert_redirected_to forms_user_path(assigns(:forms_user))
  end

  test "should destroy forms_user" do
    assert_difference('FormsUser.count', -1) do
      delete :destroy, id: @forms_user
    end

    assert_redirected_to forms_users_path
  end
end
