class Risebox::Compute::BrainUpgrade
  attr_reader :brain

  def initialize brain
    @brain = brain
  end

  def compute version, upgraded_at
    #TODO: Update brain version
    #brain.update_attributes({version: version, upgraded_at: upgraded_at})

    ds_service = Risebox::Query::DeviceSetting.new(brain.devices.first)
    updated, setting = ds_service.bulk_update({brain_version: version, brain_update: 0})
  end
end