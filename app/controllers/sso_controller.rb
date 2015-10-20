require 'sso/single_sign_on'

class SsoController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sso
    secret = SSO_SECRET

    sso = SingleSignOn.parse(request.query_string, secret)

    puts "sso.to_h #{sso.to_h}"

    #TODO Lookup User with email, if present login else reject

    sso.email = "team@risebox.co"
    sso.name = "Risebox Team"
    sso.username = "risebox_team"
    sso.external_id = "1" # unique id for each user of your application
    sso.sso_secret = secret

    redirect_to sso.to_url("http://community.risebox.co/session/sso_login")
  end
end