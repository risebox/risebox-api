class Risebox::Core::User < ActiveRecord::Base
  has_many :devices, class_name: 'Risebox::Core::Device', foreign_key: :owner_id
  has_many :registrations, class_name: 'Risebox::Core::Registration'
end
