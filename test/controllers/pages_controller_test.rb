require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:RealPerson)
    @page = pages(:one)
    sign_in @user
  end

  test "should get index" do
    get pages_url
    assert_response :success
  end

  test "should get new" do
    get new_page_url
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      post pages_url, params: { page: { name: "My new Page",
                                 description: "just messing around", 
                                    location: "Chicago, Illinois", 
                                     mission: "the greatest page in the world",
                                     website: "www.thispageisthegreatest.edu",
                                     user_id:  @user.id } }
    end

    assert_redirected_to page_url(Page.last)
  end

  test "should show page" do
    get page_url(@page)
    assert_response :success
  end

  test "should get edit" do
    get edit_page_url(@page)
    assert_response :success
  end

  test "should update page" do
    patch page_url(@page), params: { page: { name: @page.name,
                                      description: @page.description, 
                                         location: @page.location, 
                                          mission: @page.mission, 
                                          website: @page.website,
                                          user_id: @user.id } }
    assert_redirected_to page_url(@page)
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete page_url(@page)
    end

    assert_redirected_to pages_url
  end
end
