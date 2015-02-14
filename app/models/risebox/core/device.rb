class Risebox::Core::Device < ActiveRecord::Base
  before_create :generate_token

  has_many   :measures, class_name: 'Risebox::Core::Measure', dependent: :destroy
  belongs_to :owner, class_name: 'Risebox::Core::User', foreign_key: :owner_id

  scope :for_credentials,  -> (key,secret) {where(key: key, token: secret)}

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
    self.token
  end
end