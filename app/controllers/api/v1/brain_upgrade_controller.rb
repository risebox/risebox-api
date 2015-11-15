class API::V1::BrainUpgradeController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token

  before_action :load_service

  def upgrade
    upgrade_time = params[:brain_upgraded_at].present? ? Time.at(params[:brain_upgraded_at].to_i).to_datetime : Time.now
    puts "params[:version] #{params[:version]}"
    upgraded, setting = @service.compute(params[:version].to_f, upgrade_time)
    api_response [upgraded, setting]
  end

private

  def load_service
    @service = rescuer Risebox::Compute::BrainUpgrade.new(@device.brain)
  end

end