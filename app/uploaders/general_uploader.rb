# frozen_string_literal: true

class GeneralUploader < CarrierWave::Uploader::Base
  if ENV.fetch("STORAGE_PROVIDER", "fog") == "gcs"
    storage :gcloud
  else
    storage :fog
  end

  def store_dir
    ENV.fetch("GCS_FOLDER", "").to_s + "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
