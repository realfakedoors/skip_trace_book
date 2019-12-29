require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  def setup
  	@user  =  users(:RealPerson)
  	@album = albums(:CoolPics)
  	@photo = photos(:Mario)
  end

  test "photo should be valid" do
  	assert @photo.valid?
  end

  test "photo should belong to a user and an album" do
  	assert_not_nil @photo.album.user
  	assert_not_nil @photo.album
  end

end
