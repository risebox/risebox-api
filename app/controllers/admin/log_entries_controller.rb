class Admin::LogEntriesController < Admin::BaseController

  def index
    @device = Risebox::Core::Device.find_by_key(params[:device_id])
    @logs = @device.logs.recent.limit(50)
  end

end