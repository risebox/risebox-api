class RecoveryController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def rollback
    JobRunner.run(SendEmail, 'recovery_alert', params[:device_key], params[:version])
  end

end