require "test_helper"

class SignupControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_user_params = {
      username: "testuser",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
    
    @invalid_user_params = {
      username: "",
      email: "invalid-email",
      password: "short",
      password_confirmation: "mismatch"
    }
  end

  test "should create user with valid nested parameters" do
    assert_difference("User.count") do
      post signup_create_url, params: { signup: @valid_user_params }, as: :json
    end
    
    assert_response :success
    assert_not_nil response.parsed_body["csrf"]
    assert_not_nil cookies[JWTSessions.access_cookie]
  end

  test "should create user with valid flat parameters" do
    assert_difference("User.count") do
      post signup_create_url, params: @valid_user_params, as: :json
    end
    
    assert_response :success
    assert_not_nil response.parsed_body["csrf"]
    assert_not_nil cookies[JWTSessions.access_cookie]
  end

  test "should not create user with invalid parameters" do
    assert_no_difference("User.count") do
      post signup_create_url, params: { signup: @invalid_user_params }, as: :json
    end
    
    assert_response :unprocessable_entity
    assert_includes response.parsed_body["error"], "can't be blank"
  end

  test "should set httponly cookie with access token" do
    post signup_create_url, params: @valid_user_params, as: :json
    
    cookie = response.headers["Set-Cookie"]
    assert_not_nil cookie
    assert_includes cookie, "HttpOnly"
    assert_includes cookie, JWTSessions.access_cookie
    
    if Rails.env.production?
      assert_includes cookie, "Secure"
    end
  end

  test "should return csrf token in json response" do
    post signup_create_url, params: @valid_user_params, as: :json
    
    json_response = response.parsed_body
    assert_not_nil json_response["csrf"]
    assert_match /\A[a-zA-Z0-9+\/]+={0,2}\z/, json_response["csrf"]
  end

  test "should handle duplicate email" do
    # Create a user first
    User.create!(@valid_user_params)
    
    assert_no_difference("User.count") do
      post signup_create_url, params: @valid_user_params, as: :json
    end
    
    assert_response :unprocessable_entity
    assert_includes response.parsed_body["error"], "taken"
  end

  test "should handle password mismatch" do
    mismatched_params = @valid_user_params.merge(password_confirmation: "differentpassword")
    
    assert_no_difference("User.count") do
      post signup_create_url, params: { signup: mismatched_params }, as: :json
    end
    
    assert_response :unprocessable_entity
    assert_includes response.parsed_body["error"], "confirmation"
  end
end