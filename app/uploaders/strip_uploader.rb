class StripUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog

  version :white_balance do
    process :wb
  end

  def wb
    # "convert #{image} -crop #{COORD[key][:l]}x#{COORD[key][:h]}+#{COORD[key][:x]}+#{COORD[key][:y]} -resize 1x1 txt:"
    manipulate! do |img|

    end
  end

  def stamp color
    manipulate! format: "png" do |source|
      overlay_path = Rails.root.join("app/assets/images/stamp_overlay.png")
      overlay = Magick::Image.read(overlay_path).first
      source = source.resize_to_fill(70, 70).quantize(256, Magick::GRAYColorspace).contrast(true)
      source.composite!(overlay, 0, 0, Magick::OverCompositeOp)
      colored = Magick::Image.new(70, 70) { self.background_color = color }
      colored.composite(source.negate, 0, 0, Magick::CopyOpacityCompositeOp)
    end
  end

  def rounded_corner(radius = 10)
    manipulate! do |img|
      masq = ::Magick::Image.new(img.columns, img.rows).matte_floodfill(1, 1)
      ::Magick::Draw.new.
          fill('transparent').
          stroke('black').
          stroke_width(1).
          roundrectangle(0, 0, img.columns - 1, img.rows - 1, radius, radius).
          draw(masq)

      img.composite!(masq, 0, 0, Magick::LightenCompositeOp)
      img = yield(img) if block_given?
      img
    end
  end
end