class API::V1::StripsController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    launched = JobRunner.run(ComputeStripTest, params[:model], @device.key, params[:photo_key], Time.now)
    api_response [launched, nil]
  end

private

end