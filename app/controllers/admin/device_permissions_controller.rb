class Admin::DevicePermissionsController < Admin::BaseController

  def index
    @device = Risebox::Core::Device.find_by_key(params[:device_id])
    @permissions = @device.user_permissions
    @other_possible_owner_ids = Risebox::Core::User.where.not(id: @permissions.pluck(:user_id)).map{ |u| [u.pretty_name, u.id] }
  end

  def create
    @device = Risebox::Core::Device.find_by_key(params[:device_id])
    @permission = Risebox::Core::DevicePermission.new(device_permission_params.merge(device_id: @device.id))
    if @permission.save
      flash[:notice] = "Device permission successfully created."
      redirect_to admin_device_device_permissions_path(@device.key)
    else
      render :index
    end
  end

  def destroy
    @device = Risebox::Core::Device.find_by_key(params[:device_id])
    @permission = @device.user_permissions.find(params[:id])
    owner_name = @permission.user.pretty_name
    if @permission.destroy
      flash[:notice] = "#{owner_name} is no longuer an owner of #{@device.key}"
      redirect_to admin_device_device_permissions_path(@device.key)
    else
      flash[:error] = "Error while removing #{owner_name} permission. He is still a owner of #{@device.key}"
    end
  end

private
  def device_permission_params
    params.require(:device_permission).permit(:user_id)
  end

end