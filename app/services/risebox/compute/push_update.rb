class Risebox::Compute::PushUpdate

  attr_reader :update_info

  def initialize update_info
    @update_info = update_info
  end

  def compute
    puts "OK now I am computing"
    puts update_info
    [true, nil]
  end
end