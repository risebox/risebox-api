class Risebox::Access::AppRegistration

  def self.match_token token
    registration = Risebox::Core::AppRegistration.for_token(token).first
    if registration
      [true, registration]
    else
      [false, {error: :not_authorized, message: 'No token matches the one you provided'}]
    end
  end

end