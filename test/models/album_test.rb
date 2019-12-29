require 'test_helper'

class AlbumTest < ActiveSupport::TestCase

  def setup
  	@user  = users(:RealPerson)
  	@album = albums(:CoolPics)
  	@photo = @album.photos.last
  end

  test "album should be valid" do
  	assert @album.valid?
  end

  test "album should belong to a user" do
  	assert_not_nil @album.user
  end

  test "album contains a couple pictures" do
  	assert_not_nil @album.photos
  end

  test "album preview should be the most recently uploaded picture" do
  	assert @album.preview == @photo
  end

  test "if an album is deleted, its pictures should all be deleted as well" do
		@user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @photo.reload }
  end

end
