class Risebox::Compute::StripPhoto

  SCALES = { :ph  => [[236, 192, 45, 6.4], [214, 83, 112, 8.4], [248, 105, 70, 7.6], [230, 120, 37, 7.2], [253, 107, 115, 8.0], [236, 155, 38, 6.8]],
           :no2 => [[244, 188, 233, 10.0], [254, 242, 239, 1.0], [244, 201, 229, 5.0], [249, 247, 240, 0.0]],
           :no3 => [[248, 230, 238, 50.0], [249, 247, 240, 0.0], [243, 176, 229, 250.0], [248, 219, 240, 100.0], [253, 246, 244, 10.0], [245, 226, 231, 25.0]],
           :kh=>[[137, 149, 69, 6.0], [186, 174, 58, 3.0], [207, 185, 65, 0.0], [100, 130, 109, 15.0], [56, 87, 113, 20.0]],
           :gh  => [[189, 91, 66, 8.0], [112, 84, 62, 4.0], [82, 92, 64, 0.0], [221, 136, 112, 16.0]] }

  COORD =
     { no3: {l: 50, h: 50, x: 200, y: 75},
       no2: {l: 50, h: 50, x: 200, y: 350},
       # gh:  {l: 50, h: 50, x: 200, y: 2354},
       kh:  {l: 50, h: 50, x: 200, y: 2125},
       ph:  {l: 50, h: 50, x: 200, y: 2410}
      }

  attr_reader :device

  def initialize device
    @device = device
  end

  def compute key
    strip = Risebox::Manage::Strip.new(device).find(key)
    return [false, nil] unless strip

    upload_store = Storage.new(:upload)
    strip_store  = Storage.new(:strip_photos)

    # Proceed with white balance
    white_balance upload_store, strip

    #crop and compute concentrations
    crop_and_compute_metrics strip

    #TODO Store Measure

    # Store generated file on s3 Strip storage
    upload_files_to_storage strip_store, strip
    strip.computed_at = Time.now

    # Save Strip
    [strip.save, strip]

  end

private

  def white_balance upload_store, strip
    FileUtils::mkdir_p(strip.local_path) unless FileTest::directory?(strip.local_path)
    upload_store.download strip.remote_orig_path, strip.local_raw_path
    `#{Rails.root}/lib/modules/whitebalance.sh -c "rgb(185,178,162)" #{strip.local_raw_path} #{strip.local_wb_path}`
    puts `ls -al #{strip.local_path}`
  end

  def crop_and_compute_metrics strip
    puts `ls -al #{strip.local_path}`
    strip.metrics.each do |metric|
      concentration = number_from_color(strip.local_wb_path, metric)
      puts "#{metric}: #{concentration}"
    end
  end

  def crop_cmd image, key
    `convert #{image} -crop #{COORD[key][:l]}x#{COORD[key][:h]}+#{COORD[key][:x]}+#{COORD[key][:y]} -resize 1x1 txt:`
  end

  def extract_strip_color wb_image, key
    output = []
    IO.popen(crop_cmd(wb_image, key)).each do |line|
      output << line
    end
    /rgb\((?<red>.[^,]*),(?<green>.[^,]*),(?<blue>.[^\)]*)\)/ =~ output[1]
    return [red.to_i, green.to_i, blue.to_i]
  end

  def color_distance color1, color2
    distance = ((color2[0]-color1[0])*0.30)**2 + ((color2[1]-color1[1])*0.59)**2 + ((color2[2]-color1[2])*0.11)**2
    #distance = ((color2[0]-color1[0]))**2 + ((color2[1]-color1[1]))**2 + ((color2[2]-color1[2]))**2
  end

  def number_from_color wb_image, key
    strip_color = extract_strip_color(wb_image, key)
    closest_distance = nil
    closest_number = nil

    SCALES[key].each do |ref|
      distance = color_distance(strip_color, ref.first(3))
      if closest_distance.nil? || closest_distance > distance
        closest_distance = distance
        closest_number = ref[3]
      end
    end

    closest_number
  end

  def upload_files_to_storage store, strip
    upload_keys = strip.photos.reject{|k| k == :orig}
    upload_keys.each do |image_key|
      store.write_multipart(strip.send("remote_#{image_key}_path"), File.open(strip.send("local_#{image_key}_path"), 'rb'))
    end
    # strip_store.write_multipart(strip.remote_raw_path, File.open(strip.local_raw_path, 'rb'))
    # strip_store.write_multipart(strip.remote_wb_path,  File.open(strip.local_wb_path, 'rb'))
  end


end