class PictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end  
  
  # The directory where pictures are stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # Picture extensions allowed for upload.
  def extension_whitelist
    %w(jpg jpeg png)
  end
  
end
