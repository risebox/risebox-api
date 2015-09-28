class Admin::LogEntriesController < ApplicationController
  http_basic_authenticate_with name: 'dg', password: 'dg'

  def index
    @device = Risebox::Core::Device.find_by_key(params[:id])
    @logs = @device.logs.recent.limit(50)
  end

end