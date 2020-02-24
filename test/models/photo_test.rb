require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  def setup
  	@user  =  users(:RealPerson)
    @post  =  posts(:freeeeeeee)
  	@album = albums(:CoolPics)
  	@photo = photos(:Mario)
    
    @photo.photo_attachable_id = @album.id
  end

  test "photo should be valid" do
  	assert @photo.valid?
  end

  test "photo should belong to a user" do
  	assert_not_nil @photo.photo_attachable.user
  end
  
  test "photo can belong to an album or a post" do
    album_photo = Photo.new(photo_attachable_id:   @album.id,
                            photo_attachable_type: "Album")
    assert album_photo.valid?
    
    post_photo  = Photo.new(photo_attachable_id:   @post.id,
                            photo_attachable_type: "Post")
    assert post_photo.valid?
  end

end
