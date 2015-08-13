class Risebox::Compute::PushUpdate

  attr_reader :registration

  def initialize registration
    @registration = registration
  end

  def compute info
    puts "Computing PushUpdate Info"
    puts info

    if info['unregister']
      puts 'unregister'
      unregister info
    elsif info['token_invalid']
      puts 'token invalid'
      invalidate info
    else
      puts 'new token !'
      create info
    end

    [true, nil]
  end

private

  def push_token p
    p['ios_token'] || p['android_token']
  end

  def push_tokens p
    p['_push']['android_tokens'] || p['_push']['ios_tokens']
  end

  def push_reg_time p
    p['received']
  end

  def unregister p
    Risebox::Manage::PushToken.new(@registration).delete push_tokens(p)
  end

  def invalidate p
    token = p['ios_token'] || p['android_token']
    Risebox::Manage::PushToken.new(@registration).delete push_token(p)
  end

  def create p
    Risebox::Manage::PushToken.new(@registration).create(push_tokens(p), push_reg_time(p))
  end

end