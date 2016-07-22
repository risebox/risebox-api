class API::V1::LogEntriesController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token, only: :create
  before_action :load_service

  def index
    api_response @service.list
  end

  def create
    # 22/06/2016: Disable loggin to reduce database size
    # log_time = params[:logged_at].present? ? Time.at(params[:logged_at].to_i).to_datetime : Time.now
    # created, log_entry = @service.create(params[:level], params[:body], log_time)
    # api_response [created, log_entry]
    api_response [true, nil]
  end

private

  def load_service
    @service = rescuer Risebox::Query::LogEntry.new(@device)
  end

end