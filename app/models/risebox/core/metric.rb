class Risebox::Core::Metric < ActiveRecord::Base
  validates_uniqueness_of :code
end
