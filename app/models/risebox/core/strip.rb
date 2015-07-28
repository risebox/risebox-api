class Risebox::Core::Strip < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'

  def raw_photo_url
    (@raw_photo_url ||= Storage.new(:strip_photos).url(raw_photo_path)) if raw_photo_path.present?
  end

  def wb_photo_url
    (@wb_photo_url ||= Storage.new(:strip_photos).url(wb_photo_path)) if wb_photo_path.present?
  end

  ['local', 'remote'].each do |location|
    ['raw', 'wb'].each do |kind|
      define_method("#{location}_#{kind}_path") do
        self.send("#{location}_path") + "/#{kind}.jpg"
      end
    end
  end

  def path
    @path ||= "strip_#{id}"
  end

  def local_path
    @local_path ||= "#{Rails.root}/tmp/strips/device_#{device.key}/#{path}"
  end

  def remote_path
    @remote_path ||= "/device_#{device.key}/#{path}"
  end
end