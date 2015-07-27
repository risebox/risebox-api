class Risebox::Core::Strip < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'

  def raw_photo_url
    (@raw_photo_url ||= Storage.new(:strip_photos).url(raw_path)) if raw_photo_path.present?
  end

  def wb_photo_url
    (@wb_photo_url ||= Storage.new(:strip_photos).url(web_path)) if raw_photo_path.present?
  end
end