class Risebox::Access::User

  def user_for_credentials email, api_token

    if email.present?
  	  user = Risebox::Core::User.where(email: email).first
      user_logged = user.present? && Devise.secure_compare(user.api_token, api_token)
    else
      user_logged = false
    end

    if user_logged
      [true, user]
    else
      [false, {error: :not_authorized, message: 'No device matches your credentials'}]
    end

  end
end