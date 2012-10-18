class PlaceAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  #def default_url
    #"/images/fallback/" + [version_name, "default.jpeg"].compact.join('_')
  #end

  # Create different versions of your uploaded files:
  version :thumb do
     process :resize_to_fill => [160, 120]
  end

  version :web_profile do
    process :resize_to_fill => [280, 180]
  end

  version :preview2 do
    process :resize_to_fill => [50, 50]
  end

  version :preview do
    process :resize_to_fill => [50, 50]
  end

  version :mini do
    process :resize_to_fill => [25, 25]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end