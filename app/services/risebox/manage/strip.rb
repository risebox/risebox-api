class Risebox::Manage::Strip
  attr_reader :device

  def initialize device
    @device = device
  end

  def build_new model, upload_key, tested_at
    device.strips.new(model: model, upload_key: upload_key, tested_at: tested_at)
  end

  def create model, tested_at
    strip = build_new(model, tested_at)
    [strip.save, strip]
  end

  def find key
    device.strips.find key
  end