require 'test_helper'

class AccountLogsControllerTest < ActionController::TestCase
  setup do
    @account_log = account_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:account_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account_log" do
    assert_difference('AccountLog.count') do
      post :create, account_log: { account_id: @account_log.account_id, change: @account_log.change, description: @account_log.description, source: @account_log.source }
    end

    assert_redirected_to account_log_path(assigns(:account_log))
  end

  test "should show account_log" do
    get :show, id: @account_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account_log
    assert_response :success
  end

  test "should update account_log" do
    patch :update, id: @account_log, account_log: { account_id: @account_log.account_id, change: @account_log.change, description: @account_log.description, source: @account_log.source }
    assert_redirected_to account_log_path(assigns(:account_log))
  end

  test "should destroy account_log" do
    assert_difference('AccountLog.count', -1) do
      delete :destroy, id: @account_log
    end

    assert_redirected_to account_logs_path
  end
end
