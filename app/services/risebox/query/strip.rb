class Risebox::Query::Strip
  include ActionView::Helpers::DateHelper

  attr_reader :device

  def initialize device
    @device = device
  end

  def find key
    device.strips.find key
  end

  def show key
    strip = find key
    [true, { meta:     {model: strip.model, duration: (strip.test_duration.present? ? distance_of_time_in_words(strip.test_duration) : nil)} ,
             measures: strip.measures }]
  end
end