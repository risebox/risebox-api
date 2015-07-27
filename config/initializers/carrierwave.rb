CarrierWave.configure do |config|
  if STORAGE[:strip_photos][:provider] == 'Local'
    config.fog_credentials = {
      :provider               => 'Local',
      :endpoint               => STORAGE[:strip_photos][:url],
      :local_root             => STORAGE[:strip_photos][:local_root]
    }
    config.fog_directory  = STORAGE[:strip_photos][:folder]
  else
    config.fog_credentials = {
      :provider               => STORAGE[:strip_photos][:provider],
      :aws_access_key_id      => STORAGE[:strip_photos][:access_key],
      :aws_secret_access_key  => STORAGE[:strip_photos][:secret_key],
      :region                 => STORAGE[:strip_photos][:region]
    }
    config.fog_directory  = STORAGE[:strip_photos][:bucket]
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end

end