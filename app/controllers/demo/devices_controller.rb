class Demo::DevicesController < ApplicationController
  http_basic_authenticate_with name: 'dg', password: 'dg'
  
  def index
    @devices = Risebox::Core::Device.all
  end

  def show
    @device = Risebox::Core::Device.find_by_key(params[:device_key])
    if @device
      success, @statuses       = Risebox::Query::MetricStatus.new(@device).list
      @global_light            = device_global_light @statuses
      @last_connected          = device_last_connected @statuses
    else
      redirect_to demo_root_path
    end
  end

  def log
    @device = Risebox::Core::Device.find_by_key(params[:device_key])
    if @device
      @measures = @device.measures.recent.with_metric.limit(50)
    else
      redirect_to demo_root_path
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
    global_light = 'warning'
    statuses.each do |s|
      if s.light == 'success'
        global_light = 'success' if global_light == 'warning'
      elsif s.light == 'danger'
        global_light = 'danger' unless global_light == 'danger'
      end
    end
    global_light
  end

end