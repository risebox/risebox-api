class Risebox::Compute::StripPhoto
  attr_reader :device, :strip

  def initialize device
    @device = device
  end

  def build_new model, tested_at
    device.strips.new(model: model, tested_at: tested_at)
  end

  def create model, tested_at
    strip = build_new(model, tested_at)
    [strip.save, strip]
  end

  def find key
    device.strips.find key
  end

  def attach_photo key, photo_key
    strip = find(key)
    return [false, nil] unless strip
    strip.raw_photo_path = photo_key
    [strip.save, strip]
  end

  def compute_photo key
    strip = find(key)
    return [false, nil] unless strip

    storage = Storage.new(:strip_photos)
    puts "computing raw image with key #{strip.raw_photo_path}"
    storage.download strip.raw_photo_path, "#{Rails.root}/tmp/raw_strip.jpg"
    `#{Rails.root}/lib/modules/whitebalance.sh -c "rgb(185,178,162)" ./tmp/raw_strip.jpg ./tmp/white_strip.jpg`
  end

end