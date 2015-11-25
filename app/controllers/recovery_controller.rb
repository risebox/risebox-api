class RecoveryController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def rollback
    puts "Recovery call received from device #{params[:device]}: recovering to version #{params[:version]}"
    if params[:device] && params[:version]
      JobRunner.run(SendEmail, 'recovery_alert', params[:device], params[:version])
    end
    render text: "Recovery acknowledged !"
  end

end