class Admin::UsersController < Admin::BaseController

  def index
    @users = Risebox::Core::User.order(created_at: :desc)
  end

  def show
    @user = Risebox::Core::User.find(params[:id])
  end
end