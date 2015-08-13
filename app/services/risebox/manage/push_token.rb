class Risebox::Manage::PushToken
  attr_reader :registration

  def initialize registration
    @registration = registration
  end

  def build_new token, time
    registration.push_tokens.new(token: token, registered_at: time)
  end

  def create token, time
    push_token = build_new(token, time)
    [push_token.save, push_token]
  end

  def finds tokens
    registration.push_tokens.for_token(tokens)
  end

  def find token
    finds(token).first
  end

  def delete tokens
    registration.push_tokens.destroy_all(finds)
  end
end