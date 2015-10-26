class Account::SessionsController < Devise::SessionsController
  before_action :allow_all_origins, only: :new

  def new
    super
  end

private
  def allow_all_origins
    response.headers["X-Frame-Options"] = "ALLOWALL"
  end
end