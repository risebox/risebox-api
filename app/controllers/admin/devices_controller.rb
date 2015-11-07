class Admin::DevicesController < Admin::BaseController

  def index
    @devices = Risebox::Core::Device.all
  end

  def show
    @device = Risebox::Core::Device.find_by_key(params[:id])
    if @device
      success, @statuses       = Risebox::Query::MetricStatus.new(@device).list
      @global_light            = device_global_light @statuses
      @last_connected          = @device.settings_queried_at
    else
      redirect_to admin_root_path
    end
  end

  def log
    @device = Risebox::Core::Device.find_by_key(params[:device_key])
    if @device
      @measures = @device.measures.recent.with_metric.limit(50)
    else
      redirect_to admin_root_path
    end
  end

private

  def device_last_connected statuses
    last_connected = nil
    statuses.each do |s|
      last_connected = s.taken_at if (s.taken_at.present? && (last_connected.nil? || last_connected < s.taken_at))
    end
    last_connected
  end

  def device_global_light statuses
    global_light = 'grey'
    statuses.each do |s|
      if s.light == 'green'
        global_light = 'green' if global_light == 'grey'
      elsif s.light == 'red'
        global_light = 'red' unless global_light == 'red'
      end
    end
    global_light
  end

end