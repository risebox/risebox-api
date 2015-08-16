class API::V1::StripsController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token

  def create
    launched = JobRunner.run(ComputeStripTest, params[:model], @device.key, params[:upload_key], Time.now)
    api_response [launched, nil]
  end

  def show
    puts "params #{params}"
    svc = rescuer Risebox::Query::Strip.new(@device)
    res = svc.show(params[:id])
    puts "res #{res}"
    api_response res
  end

private

end