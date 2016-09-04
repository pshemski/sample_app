require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @title_base = "Ruby on Rails Tutorial Sample App"
  end

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@title_base}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@title_base}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@title_base}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@title_base}"
  end

end
