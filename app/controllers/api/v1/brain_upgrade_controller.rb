class API::V1::BrainUpgradeController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token

  before_action :load_service

  def upgrade
    puts "Brain acknowledging successful version upgrade to version #{params[:version]}"
    api_response acknowledge_version_change
  end

  def rollback
    puts "Recovery call received from device #{@device.name}: recovering to version #{params[:version]}"
    UserMailer.recovery_alert(params[:device], params[:version]).deliver
    api_response acknowledge_version_change
  end

private

  def acknowledge_version_change
    upgrade_time = params[:brain_upgraded_at].present? ? Time.at(params[:brain_upgraded_at].to_i).to_datetime : Time.now
    puts "Brain acknowledging change to version #{params[:version]}"
    upgraded, setting = @service.compute(params[:version].to_f, upgrade_time)
    return [upgraded, setting]
  end

  def load_service
    @service = rescuer Risebox::Compute::BrainUpgrade.new(@device.brain)
  end

end