class Risebox::Core::Registration < ActiveRecord::Base
  before_create :generate_token

  belongs_to :user,   class_name: 'Risebox::Core::User'
  belongs_to :device, class_name: 'Risebox::Core::Device'

  has_many   :push_tokens

  scope :for_token, -> (token) {where(token: token)}
  scope :with_user_and_device, -> { joins([:user, :device]).includes([:user, :device]) }

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
    self.token
  end
end