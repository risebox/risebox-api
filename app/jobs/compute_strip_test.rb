class ComputeStripTest < JobBase
  acts_as_scalable

  @queue  = :strips

  def self.perform locale, model, device_id, upload_key, tested_at
    #TODO: Replace by a service ?
    return unless device = Risebox::Core::Device.find_by_key(device_id)

    # Create photo
    manager = Risebox::Manage::Strip.new(device)
    strip_created, strip = manager.create(model, upload_key, DateTime.parse(tested_at))

    # Compute Photo to determine concentrations
    computer = Risebox::Compute::StripPhoto.new(device)
    strip_updated, strip = computer.compute strip.id
    puts "DONE computing result : #{strip_updated}"

    # Push notification
    notifier = Risebox::Notify::StripResult.new(device.owner)
    notifier.notify strip
    puts "DONE notifying"
  end
end