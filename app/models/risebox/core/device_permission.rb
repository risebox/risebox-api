class Risebox::Core::DevicePermission < ActiveRecord::Base
	belongs_to :device, class_name: 'Risebox::Core::Device'
	belongs_to :user, class_name: 'Risebox::Core::User'
end
