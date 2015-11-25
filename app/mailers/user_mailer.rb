class UserMailer < ActionMailer::Base
  require 'email_header.rb'
  helper :application

  # default "notification@risebox.co"
  layout 'mailer'

  def device_alert metric_status
    headers['X-SMTPAPI'] = single_recipient_header 'device_alert'
    @metric_status = metric_status
    @metric        = metric_status.metric
    metric_status.device.owners.each do |user|
      mail(to: user.email, subject: "Votre Risebox demande votre attention")
    end
  end

  def recovery_alert device_key, version
    mail(to: "team@risebox.co", body: "Risebox #{device_key} is rolling back to version #{version}. Check if everything is ok", content_type: "text/html", subject: "Risebox #{device_key} in recovery mode !")
  end

private

  def single_recipient_header category, bypass_list_management=false
    hd = EmailHeader.new(nil, category, nil)
    hd.add_filter_setting('bypass_list_management', 'enable', 1) if bypass_list_management
    hd.as_json
  end
end