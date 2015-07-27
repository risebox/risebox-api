class Risebox::Core::Strip < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'
end