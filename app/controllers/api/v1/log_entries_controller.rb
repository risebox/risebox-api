class API::V1::LogEntriesController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token, only: :create
  before_action :load_service

  def index
    api_response @service.list
  end

  def create
    created, log_entry = @service.create(params[:level], params[:body], params[:logged_at])
    api_response [created, log_entry]
  end

private

  def load_service
    @service = rescuer Risebox::Query::LogEntry.new(@device)
  end

end