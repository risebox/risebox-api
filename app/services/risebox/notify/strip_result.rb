require 'faraday'

class Risebox::Notify::StripResult

  attr_reader :user

  def initialize user
    @user = user
  end

  def notify strip
    tokens = user.push_tokens

    api_post '', message(tokens).to_json, nil
  end

  def status message_id
    `curl -H "Content-Type: application/json" -H "X-Ionic-Application-Id: #{ENV['IONIC_APP_ID']}" https://push.ionic.io/api/v1/status/#{message_id} -u #{ENV['IONIC_PUSH_PRIVATE_KEY']}:`
  end

private
  def get_connection args
    Faraday.new(args)
  end

  def perform_request! verb, conn, url, form_params=nil
    begin
      result = http_call(verb, conn, url, form_params)
    rescue Faraday::Error::TimeoutError
      raise :TimeOutError, 'Ionic Timeout'
    end
    puts result.status
    case result.status
    when 200
      puts result.body
    when 202
      puts result.body
    when 403
      raise :ForbiddenError, 'Ionic Bad credentials'
    when 404
      raise :NotFoundError, 'Ionic Ressource not found'
    when 500
      raise :AppError, 'Ionic Application error'
    end
  end

  def http_call verb, conn, url, form_params=nil
    result = conn.public_send(verb) do |req|
      req.url url
      req.body = form_params if verb == :post
      req.options[:timeout]       = 5
      req.options[:open_timeout]  = 2
    end
  end

  def api_get url, options
    api_call :get, url, nil, options
  end

  def api_post url, form_params, options
    api_call :post, url, form_params, options
  end

  def api_call verb, url, form_params, options
    conn   = get_connection(url: ENV['IONIC_PUSH_URL'])

    conn.basic_auth(ENV['IONIC_PUSH_PRIVATE_KEY'], '')

    conn.headers['Content-Type']           = 'application/json'
    conn.headers['X-Ionic-Application-Id'] = ENV['IONIC_APP_ID']

    perform_request!(verb, conn, url, form_params)
  end

  # curl -H "Content-Type: application/json" -H "X-Ionic-Application-Id: d49a75b8" https://push.ionic.io/api/v1/status/79ac169c42ee11e5ae316a0f340bf48c -u 7ce0fe29c5bf8e8dbd2c131a0131484154ed8807d53e5759:

  def message tokens
    {
      tokens: [
        tokens.pluck(:token).join(',')
      ],
      notification: {
        alert: "Analyse terminée!",
        ios: {
          badge: 1,
          sound: "ping.aiff",
          expiry: 1423238641,
          priority: 10,
          contentAvailable: true,
          payload: {
            key1: "value",
            key2: "value"
          }
        },
        android: {
          collapseKey: "foo",
          delayWhileIdle: true,
          timeToLive: 300,
          payload: {
            key1: "value",
            key2: "value"
          }
        }
      }
    }
  end

end