class ComputeStripTest < JobBase
  acts_as_scalable

  @queue  = :strips

  def self.perform locale, model, device_id, photo_key, tested_at
    return unless device = Risebox::Core::Device.find_by_key(device_id)

    # Create photo
    service = Risebox::Compute::StripPhoto.new(device)
    strip_created, strip = service.create(model, DateTime.parse(tested_at))

    #Attach Photo
    service.attach_photo strip.id, photo_key

    # Compute Photo to determine concentrations
    service.compute_photo strip.id

    # Push notification
    # service.notify_owner
  end
end