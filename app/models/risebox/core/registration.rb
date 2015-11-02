class Risebox::Core::AppRegistration < ActiveRecord::Base
  before_create :generate_token

  belongs_to :user,   class_name: 'Risebox::Core::User'

  has_many   :push_tokens

  scope :for_token, -> (token) {where(token: token)}
  scope :with_user, -> { joins(:user).includes(:user) }

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
    self.token
  end
end