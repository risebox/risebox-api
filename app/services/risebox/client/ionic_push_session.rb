module Risebox
  module Client
    class IonicPushSession < Risebox::Client::Session

      def send_notification message
        api_post "/api/v1/push", message, nil
      end

      def message_status message_id
        api_post "/api/v1/status/#{message_id}", nil, nil
      end

    private

      #TODO use options to setup basic_auth, and headers and define an agnostic api_call method in Risebox::Client::Session
      def api_call verb, url, form_params, options
        conn   = get_connection(url: ENV['IONIC_PUSH_URL'])

        conn.basic_auth(ENV['IONIC_PUSH_PRIVATE_KEY'], '')

        conn.headers['Content-Type']           = 'application/json'
        conn.headers['X-Ionic-Application-Id'] = ENV['IONIC_APP_ID']

        perform_request_with_raise_or_not verb, conn, url, form_params
      end

    end
  end
end