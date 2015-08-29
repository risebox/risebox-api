class Risebox::Core::Strip < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'

  def metrics
    [:ph, :no2, :no3, :kh]
  end

  def photos
    [:orig, :raw, :wb]
  end

  def locations
    [:local, :remote]
  end

  def files
    metrics + photos
  end

  [:local, :remote].each do |location|
    [:ph, :no2, :no3, :kh, :orig, :raw, :wb].each do |kind|
      define_method("#{location}_#{kind}_path") do
        if kind == :orig
          upload_key
        else
          self.send("#{location}_path") + "/#{kind}.png"
        end
      end
      define_method("#{location}_#{kind}_url") do
        return "" if location == :local
        new_storage(kind).url self.send("#{location}_#{kind}_path")
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
    @remote_path ||= "device_#{device.key}/#{path}"
  end

  def test_duration
    (tested_at && computed_at) ? computed_at.to_i - tested_at.to_i : nil
  end

  def measures
    measures = {}
    metrics.each{|metric| measures[metric] = self.attributes[metric.to_s]}
    measures
  end


private

  def storage_for_kind kind
    kind == :orig ? :upload : :strip_photos
  end

  def new_storage kind
    Storage.new(storage_for_kind(kind))
  end

end