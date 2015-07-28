class Risebox::Compute::StripPhoto
  attr_reader :device

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
    puts "START computing raw image with key #{strip.raw_photo_path}"

    FileUtils::mkdir_p(strip.local_path) unless FileTest::directory?(strip.local_path)

    # local_raw_path = local_path + "/raw_strip.jpg"
    # local_wb_path  = local_path + "/white_strip.jpg"

    storage.download strip.raw_photo_path, strip.local_raw_path
    wb = `#{Rails.root}/lib/modules/whitebalance.sh -c "rgb(185,178,162)" #{strip.local_raw_path} #{strip.local_wb_path}`

    # storage.write_multipart('1/raw_strip1438041631065.jpg', File.open(local_wb_path, 'rb'))
    storage.write_multipart(strip.remote_wb_path, File.open(strip.local_wb_path, 'rb'))
    strip.wb_photo_path = strip.remote_wb_path
    strip.save!

    puts `ls -al #{strip.local_path}`
    puts "DONE compute photo"
  end

end