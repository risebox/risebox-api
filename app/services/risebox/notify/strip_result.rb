class Risebox::Notify::StripResult

  attr_reader :user

  def initialize user
    @user = user
  end

  def notify strip
    tokens  = user.push_tokens
    message = Risebox::Notify::Message.new.generate(tokens, "Analyse terminée !", 'strip_result', {strip_id: strip.id})
    result  = Risebox::Client::IonicPushSession.new.send_notification message
  end

end