class Risebox::Core::User < ActiveRecord::Base
  has_many :devices_permissions, class_name: 'Risebox::Core::DevicePermission'
  has_many :devices, class_name: 'Risebox::Core::Device', through: :devices_permissions
  has_many :registrations, class_name: 'Risebox::Core::Registration'
  has_many :push_tokens, through: :registrations, class_name: 'Risebox::Core::PushToken'

  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable, :validatable
  #:confirmable,

  before_validation :generate_password_if_not_set_and_not_human
  before_create :generate_api_token

  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token)
    self.api_token
  end

  def generate_password_if_not_set_and_not_human
  	return unless password.nil? && !human
  	psw = SecureRandom.hex
  	self.password = psw
  	self.password_confirmation = psw
  end
end
