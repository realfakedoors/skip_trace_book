require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user  =  users(:RealPerson)
    @album = albums(:AlbumOne)
    sign_in @user
  end

  test "should get new" do
    get new_album_url
    assert_response :success
  end

  test "should create album" do
    assert_difference('Album.count') do
      post albums_url, params: { album: { description: "Awesome Pics", title: "Pictures", user_id: @user.id } }
    end

    assert_redirected_to album_url(Album.last)
  end

  test "should show album" do
    get album_url(@album)
    assert_response :success
  end

  test "should destroy album" do
    assert_difference('Album.count', -1) do
      delete album_url(@album)
    end

    assert_redirected_to root_url
  end
end