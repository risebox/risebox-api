class RecoveryController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def rollback
    puts "Recovery call received from device #{params[:device]}: recovering to version #{params[:version]}"
    if params[:device] && params[:version]
      mail(to: "team@risebox.co",
           body: "Risebox #{params[:device]} is rolling back to version #{params[:version]}. Check if everything is ok",
           content_type: "text/html",
           subject: "Risebox #{params[:device]} in recovery mode !")
    end
    render text: "Recovery acknowledged !"
  end

end