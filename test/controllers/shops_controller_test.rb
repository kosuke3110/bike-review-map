require "test_helper"

class ShopsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get shops_search_url
    assert_response :success
  end

  test "should get result" do
    get shops_result_url
    assert_response :success
  end
end
