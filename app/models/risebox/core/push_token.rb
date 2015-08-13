class Risebox::Core::PushToken < ActiveRecord::Base
  belongs_to :registration,   class_name: 'Risebox::Core::Registration'

  scope :for_token, -> (token) {where(token: token)}
end