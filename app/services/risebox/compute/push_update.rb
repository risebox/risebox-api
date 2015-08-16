class Risebox::Compute::PushUpdate

  attr_reader :registration, :info

  def initialize registration
    @registration = registration
  end

  def compute info
    @info = info
    puts "Computing PushUpdate Info coming from Ionic Push via web_hook"
    # puts info

    if info['unregister']
      puts 'unregister'
      unregister
    elsif info['token_invalid']
      puts 'token invalid'
      invalidate
    else
      puts 'new token !'
      create
    end

    [true, nil]
  end

private

  def ios_token
    info['ios_token']
  end

  def android_token
    info['android_token']
  end

  def android_tokens
    info['_push']['android_tokens']
  end

  def ios_tokens
    info['_push']['ios_tokens']
  end

  def push_tokens
    ios_tokens || android_tokens
  end

  def push_token
    ios_token || android_token
  end

  def push_reg_time
    info['received'].present? ? Time.parse(info['received']) : nil
  end

  def unregister
    service.delete push_tokens
  end

  def invalidate
    service.delete push_token
  end

  def do_create_unless_exist list, token, platform
    service.create(token, platform, push_reg_time) unless list.pluck(:platform, :token).include?([platform.to_s, token])
  end

  def create
    list = service.list
    [:ios, :android].each do |platform|
      platform_tokens = self.send("#{platform}_tokens")
      if platform_tokens.present?
        if platform_tokens.try(:many?)
          platform_tokens.each do |pt|
            do_create_unless_exist list, pt, platform
          end
        else
          do_create_unless_exist list, platform_tokens.first, platform
        end
      end
    end
  end

  def service
    Risebox::Manage::PushToken.new(@registration)
  end

end