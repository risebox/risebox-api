module Risebox
  module Client
    class Session

      include Risebox::Client::Connection

      def initialize raise_errors=true
        @raise  = raise_errors
      end

      def api_get url, options
        api_call :get, url, nil, options
      end

      def api_post url, form_params, options
        api_call :post, url, form_params, options
      end

      def perform_request_with_raise_or_not verb, conn, url, form_params
        if @raise
          perform_request!(verb, conn, url, form_params)
        else
          perform_request(verb, conn, url, form_params)
        end
      end

    end
  end
end