class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :allow_all_origins, if: :account_controller?
private

  def account_controller?
    params[:controller].split('/').first == 'devise'
  end

  def allow_all_origins
    response.headers["X-Frame-Options"] = "ALLOWALL"
  end
end
