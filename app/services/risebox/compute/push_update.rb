class Risebox::Compute::PushUpdate

  attr_reader :registration, :info

  def initialize registration
    @registration = registration
  end

  def compute info
    @info = info
    puts "Computing PushUpdate Info"
    puts info

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

  def do_create_unless_exist list, pt, platform
    service.create(pt, platform, push_reg_time) unless list.pluck(:platform, :token).include?([platform, pt])
  end

  def create
    list = service.list
    [:ios, :android].each do |platform|
      puts "platform tokens for #{platform} :"
      puts self.send("ios_tokens")

      puts "info['_push']['ios_tokens']"
      puts info['_push']['ios_tokens']

      puts "info['_push']['android_tokens']"
      puts info['_push']['android_tokens']

      platform_tokens = self.send("#{platform}_tokens")
      if platform_tokens.present?
        puts "tokens are present for #{platform}"

        puts "list.pluck(:platform, :token)"
        puts list.pluck(:platform, :token)

        if platform_tokens.try(:many?)
          puts "creating many"

          platform_tokens.each do |pt|
            puts "list.pluck(:platform, :token).include?([platform, pt])"
            puts list.pluck(:platform, :token).include?([platform, pt])

            do_create_unless_exist list, pt, platform
          end
        else
          puts "creating one"
          do_create_unless_exist list, pt, platform
        end
      end
    end
    # ios_tokens.each do |it|
    #   service.create(it, push_reg_time) unless list.pluck([[:platform, :token].include?([:ios, it])
    # end
    # android_tokens.each do |at|
    #   service.create(at, push_reg_time) unless list.pluck([[:platform, :token].include?([:ios, it])
    # end
  end

  def service
    Risebox::Manage::PushToken.new(@registration)
  end

end