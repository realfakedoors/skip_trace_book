require 'test_helper'

class PhotosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @album = albums(:CoolPics)
    @photo = photos(:Mario)
    @user  = users(:RealPerson)
    sign_in @user
  end

  test "should create photo" do
    photo = fixture_file_upload('files/puppy.png', 'image/png')
    assert_difference('Photo.count') do
      post photos_url, params: { photo: { photo_attachable_id: @album.id,
                                        photo_attachable_type: "Album",
                                                        title: "cat",
                                                  description: "Dog Photo", 
                                                   photo_data: photo  } }
    end
  end

  test "photo data should be less than 5MB" do
    huge_photo = fixture_file_upload('files/huge.jpg', 'image/jpg')
    post photos_url, params: { photo: { photo_attachable_id: @album.id,
                                      photo_attachable_type: "Album",
                                                      title: "massive photo",
                                                description: "this is a bit too big",
                                                 photo_data: huge_photo }}
    assert_redirected_to root_url
  end

  test "should get edit" do
    get edit_photo_path(@photo)
    assert_response :success
  end

  test "should update successfully" do
    new_title = "Dope Ass Photo"
    new_desc  = "A gorilla jumping off a waterfall"
    patch photo_path(@photo), params: { photo: { title: new_title, 
                                           description: new_desc } }
    assert_redirected_to :photo

    @photo.reload
    assert @photo.title       == new_title
    assert @photo.description == new_desc
  end

  test "should show photo" do
    get photo_url(@photo)
    assert_response :success
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete photo_url(@photo)
    end
  end
end
