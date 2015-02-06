class Risebox::Core::Device < ActiveRecord::Base
  has_many :measures, class_name: 'Risebox::Core::Measure', dependent: :destroy

  scope :for_credentials,  -> (key,secret) {where(key: key, token: secret)}
end