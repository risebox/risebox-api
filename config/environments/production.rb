Rails.application.configure do

  if ENV['APP_NAME'].present?
    require "#{Rails.root}/config/environments/_#{ENV['APP_NAME']}.rb"
  else
    require "#{Rails.root}/config/environments/_rbdev-api.rb"
  end

  IONIC_APP_ID   ='d49a75b8'
  IONIC_PUSH_URL = 'https://push.ionic.io'

  REDIS_PROVIDER_URL = ENV['REDISTOGO_URL']

  NEWRELIC_API_URL = "https://api.newrelic.com/api/v1/accounts/#{ENV['NEW_RELIC_ID']}/applications/#{ENV['NEW_RELIC_APP_ID']}"

  # Settings specified here will take precedence over those in config/application.rb.
  WORKER_AUTOSCALE = ENV['WORKER_AUTOSCALE'] == 'true'
  SCALER_CONFIG = {
                    default:    {min_workers: 0, max_workers: 1, job_threshold: 1, queues: 'send_emails,strips,agregate_measures' }
                  }

  JOBS_RUN         = true
  JOBS_SYNCHRONOUS = true #22/07/2016 to reduce cost

  TEST_EMAIL        = "test@risebox.co"
  MAILS_INTERCEPTED = ENV['MAILS_INTERCEPTED'] == 'true'

  SSO_SECRET = ENV['SSO_SECRET']

  config.to_prepare { Devise::SessionsController.force_ssl }
  config.to_prepare { Devise::RegistrationsController.force_ssl }
  config.to_prepare { Devise::PasswordsController.force_ssl }

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method       = :smtp
  config.action_mailer.default_options       = { from:      'Risebox <contact@risebox.co>',
                                                 reply_to:  'no-reply@risebox.co' }
  config.action_mailer.default_url_options   = { protocol: 'https', host: 'risebox-api.herokuapp.com' }
  config.action_mailer.smtp_settings = {
    address:        "smtp.sendgrid.net",
    port:           "587",
    authentication: :plain,
    user_name:      ENV['SENDGRID_USERNAME'],
    password:       ENV['SENDGRID_PASSWORD'],
    domain:         'risebox.co'
  }

  # mail interception for pre-production envs
  if MAILS_INTERCEPTED
    require 'mail/outgoing_mail_interceptor'
    ActionMailer::Base.register_interceptor OutgoingMailInterceptor
  end

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
