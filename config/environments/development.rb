Rails.application.configure do
  #Load .env content as ENV variables used for ENV['PORT']
  Hash[File.read('.env').scan(/(.+?)=(.+)/)].each {|k,v| ENV[k.to_s] = v} if File.exist?('.env')
  ENV['PORT'] ||= '3000'

  IONIC_APP_ID   ='d49a75b8'
  IONIC_PUSH_URL = 'https://push.ionic.io'

  REDIS_PROVIDER_URL = 'redis://localhost:6379/'

  NEWRELIC_API_URL = 'https://api.newrelic.com/api/v1/accounts/123/applications/234'

  SSO_SECRET = ENV['SSO_SECRET']

  # STORAGE = {
  #   strip_photos: {
  #         provider: 'Local',
  #         url: "/app/storage_mock",
  #         local_root: "public/system/#{Rails.env}/tmp",
  #         folder: "strip_photos",
  #         conditions: { size: 5242880 }
  #   }
  # }

  STORAGE = {
    upload: {
          provider:   'AWS',
          url:        "//risebox-upload-local.s3-external-3.amazonaws.com",
          access_key: ENV['S3_KEY'],
          secret_key: ENV['S3_SECRET'],
          bucket:     'risebox-upload-local',
          conditions: { size: 5242880 },
          region:     'eu-west-1'
                  },
    strip_photos: {
          provider:   'AWS',
          url:        "//risebox-strips-local.s3-external-3.amazonaws.com",
          access_key: ENV['S3_KEY'],
          secret_key: ENV['S3_SECRET'],
          bucket:     'risebox-strip-local',
          conditions: { size: 5242880 },
          region:     'eu-west-1'
                  }
  }

  # Settings specified here will take precedence over those in config/application.rb.
  WORKER_AUTOSCALE = false
  SCALER_CONFIG = {
                    default:    {min_workers: 0, max_workers: 1, job_threshold: 1, queues: 'send_emails,strips,agregate_measures' }
                  }
  JOBS_RUN         = true
  JOBS_SYNCHRONOUS = true

  TEST_EMAIL        = ''
  MAILS_INTERCEPTED = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options   = { host: "localhost:#{ENV['PORT']}" }
  config.action_mailer.delivery_method       = :test
  config.action_mailer.default_options       = { from:      'Risebox <contact@risebox.co>',
                                                 reply_to:  'no-reply@risebox.co' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
