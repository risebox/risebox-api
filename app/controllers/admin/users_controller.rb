class Admin::UsersController < Admin::BaseController

  def index
    @users = Risebox::Core::User.order(created_at: :desc)
  end

  def show
    @user = Risebox::Core::User.find(params[:id])
  end

  def new
    @user = Risebox::Core::User.new
  end

  def create
    @user = Risebox::Core::User.new(user_params)
    if @user.save
      flash[:notice] = "User successfully created."
      redirect_to admin_user_path(@user)
    else
      puts "@user.errors #{@user.errors.to_yaml}"
      render :new
    end
  end

  def edit
    @user = Risebox::Core::User.find(params[:id])
  end

  def update
    @user = Risebox::Core::User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "User successfully updated."
      redirect_to admin_user_path(@user)
    else
      puts "@user.errors #{@user.errors.to_yaml}"
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:human, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end