require 'sso/single_sign_on'

class Account::SsoController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :ensure_correct_sso, :authenticate_user!

  def sso
    puts "sso.email #{@sso.email}"
    puts "sso.custom_fields #{@sso.custom_fields}"

    @sso.email = current_user.email
    # @sso.name = "Risebox Team"
    @sso.username = current_user.pretty_name
    @sso.admin    = current_user.admin?
    @sso.external_id = current_user.id # unique id for each user of your application
    @sso.sso_secret = SSO_SECRET

    redirect_to @sso.to_url("http://community.risebox.co/session/sso_login")
  end

private

  def ensure_correct_sso
    @sso = SingleSignOn.parse(request.query_string, SSO_SECRET)
  end

end