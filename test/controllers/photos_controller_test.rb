require 'test_helper'

class PhotosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @album = albums(:AlbumOne)
    @photo = photos(:PhotoOne)
    @user  =  users(:RealPerson)
    sign_in @user
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post photos_url, params: { photo: { album_id: @album.id, description: "Dog Photo", photo_data: "puppy.jpg", title: "cat" } }
    end

    assert_redirected_to Photo.last
  end

  test "should show photo" do
    get photo_url(@photo)
    assert_response :success
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete photo_url(@photo)
    end

    assert_redirected_to photos_url
  end
end
