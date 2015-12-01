class Risebox::Compute::StripPhoto

  # TETRA Strip from Risebox-pi
  # SCALES = { :ph  => [[236, 192, 45, 6.4], [214, 83, 112, 8.4], [248, 105, 70, 7.6], [230, 120, 37, 7.2], [253, 107, 115, 8.0], [236, 155, 38, 6.8]],
  #          :no2 => [[244, 188, 233, 10.0], [254, 242, 239, 1.0], [244, 201, 229, 5.0], [249, 247, 240, 0.0]],
  #          :no3 => [[248, 230, 238, 50.0], [249, 247, 240, 0.0], [243, 176, 229, 250.0], [248, 219, 240, 100.0], [253, 246, 244, 10.0], [245, 226, 231, 25.0]],
  #          :kh =>[[137, 149, 69, 6.0], [186, 174, 58, 3.0], [207, 185, 65, 0.0], [100, 130, 109, 15.0], [56, 87, 113, 20.0]],
  #          :gh  => [[189, 91, 66, 8.0], [112, 84, 62, 4.0], [82, 92, 64, 0.0], [221, 136, 112, 16.0]] }

  # JBL Strip from self.compute_scales (with white-balance)
  SCALES = { :ph=>[[255, 239, 81, 6.4], [247, 181, 28, 6.8], [238, 104, 6, 7.2], [251, 94, 40, 7.6], [221, 69, 53, 8.0], [205, 57, 69, 8.4], [170, 52, 96, 9.0]],
             :no2=>[[244, 248, 227, 0.0], [249, 227, 241, 2.0], [255, 214, 250, 5.0], [255, 179, 240, 10.0]],
             :no3=>[[244, 248, 227, 10.0], [245, 228, 232, 25.0], [254, 234, 248, 50.0], [248, 158, 223, 250.0], [231, 97, 190, 500.0]],
             :kh=>[[201, 193, 66, 0.0], [157, 158, 29, 3.0], [91, 108, 37, 6.0], [76, 108, 49, 10.0], [41, 67, 50, 15.0], [16, 35, 53, 20.0]] }

  COORD =
     { no3: {l: 20, h: 20, x_ratio: 0.40, y_ratio: 0.03},
       no2: {l: 20, h: 20, x_ratio: 0.40, y_ratio: 0.11},
       # gh:  {l: 50, h: 50, x: 200, y: 2354},
       kh:  {l: 20, h: 20, x_ratio: 0.40, y_ratio: 0.66},
       ph:  {l: 20, h: 20, x_ratio: 0.40, y_ratio: 0.724}
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

  def compute_scales path
    scales = { ph: [], no2: [], no3: [], kh:  [] }

    wb_path = path + "/wb"

    FileUtils.rm_rf wb_path if FileTest::directory?(wb_path)
    FileUtils::mkdir_p(wb_path)

    Dir.glob(path + '/*').each do |f|
      unless FileTest::directory?(f)
        splitted = File.basename(f, File.extname(f)).split('_')
        metric   = splitted.first.to_sym
        value    = splitted.last.to_f

        wb_file_path = wb_path + '/' + File.basename(f)
        wb_cmd f, wb_file_path

        scales[metric] << extract_scale_color(wb_file_path).append(value)
      end
    end

    puts "computed scales : #{scales}"
  end

private

  def white_balance upload_store, strip
    FileUtils::mkdir_p(strip.local_path) unless FileTest::directory?(strip.local_path)
    upload_store.download strip.remote_orig_path, strip.local_raw_path
    wb_cmd strip.local_raw_path, strip.local_wb_path
  end

  def image_dimensions image_path
    width, height = identify_img_cmd(image_path).split(',')
  end

  def crop_and_compute_metrics strip
    strip.metrics.each do |metric|
      concentration = number_from_color(strip.local_wb_path, metric, strip.send("local_#{metric}_path"))
      puts "#{metric}: #{concentration}"
      strip.send("#{metric}=", concentration)
    end
  end

  def crop_img_cmd image, key, crop_image, width, height
    `convert #{image} -crop #{COORD[key][:l]}x#{COORD[key][:h]}+#{(COORD[key][:x_ratio]*width.to_i).to_i}+#{(COORD[key][:y_ratio]*height.to_i).to_i} #{crop_image}`
  end

  def crop_txt_cmd image, key, width, height
    "convert #{image} -crop #{COORD[key][:l]}x#{COORD[key][:h]}+#{(COORD[key][:x_ratio]*width.to_i).to_i}+#{(COORD[key][:y_ratio]*height.to_i).to_i} -resize 1x1 txt:"
  end

  def identify_img_cmd image
    `identify -format \"%w,%h\" #{image}`
  end

  def scale_txt_cmd image
    "convert #{image} -resize 1x1 txt:"
  end

  def wb_cmd image, wb_image
    `#{Rails.root}/lib/modules/whitebalance.sh -c "rgb(185,178,162)" #{image} #{wb_image}`
  end

  def extract_strip_color wb_image, key, crop_image
    output = []
    width, height = image_dimensions(wb_image)
    crop_img_cmd(wb_image, key, crop_image, width, height)
    IO.popen(crop_txt_cmd(wb_image, key, width, height)).each do |line|
      output << line
    end
    /rgba\((?<red>.[^,]*),(?<green>.[^,]*),(?<blue>.[^,]*),/ =~ output[1]
    return [red.to_i, green.to_i, blue.to_i]
  end

  def extract_scale_color path
    output = []
    IO.popen(scale_txt_cmd(path)).each do |line|
      output << line
    end
    /rgba\((?<red>.[^,]*),(?<green>.[^,]*),(?<blue>.[^,]*),/ =~ output[1]
    return [red.to_i, green.to_i, blue.to_i]
  end

  def color_distance color1, color2
    distance = ((color2[0]-color1[0])*0.30)**2 + ((color2[1]-color1[1])*0.59)**2 + ((color2[2]-color1[2])*0.11)**2
    #distance = ((color2[0]-color1[0]))**2 + ((color2[1]-color1[1]))**2 + ((color2[2]-color1[2]))**2
  end

  def number_from_color wb_image, key, crop_image
    strip_color = extract_strip_color(wb_image, key, crop_image)
    puts "Extracted RGB color for #{key}: #{strip_color}"

    closest_distance = nil
    closest_number = nil

    puts "Comparing metric #{key} with references"
    SCALES[key].each do |ref|
      distance = color_distance(strip_color, ref.first(3))
      puts "Distance for #{key}: #{distance} for #{ref[3]}"
      if closest_distance.nil? || closest_distance > distance
        closest_distance = distance
        closest_number = ref[3]
      end
    end

    puts "Closest is #{closest_number}"

    closest_number
  end

  def upload_files_to_storage store, strip
    upload_keys = strip.files.reject{|k| k == :orig}
    upload_keys.each do |image_key|
      store.write_multipart(strip.send("remote_#{image_key}_path"), File.open(strip.send("local_#{image_key}_path"), 'rb'))
    end
  end

end