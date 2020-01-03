require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user  =  users(:RealPerson)
    @album = albums(:CoolPics)
    sign_in @user
  end

  test "should get index" do
    get albums_user_url(@user)
    assert_response :success
  end

  test "should get new" do
    get new_album_url
    assert_response :success
  end

  test "should create album" do
    assert_difference('Album.count') do
      post albums_url, params: { album: { description: "Awesome Pics", title: "Pictures", user_id: @user.id } }
    end
  end

  test "should show album" do
    get album_url(@album)
    assert_response :success
  end

  test "should get edit" do
    get edit_album_url(@album)
    assert_response :success
  end

  test "should update successfully" do
    new_title = "Sick Pics"
    new_desc  = "amazing photos"
    patch album_path(@album), params: { album: { title: new_title, description: new_desc } }

    @album.reload
    assert @album.title == new_title
    assert @album.description == new_desc
  end

  test "should destroy album" do
    assert_difference('Album.count', -1) do
      delete album_url(@album)
    end

    assert_redirected_to root_url
  end
end