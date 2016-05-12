require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InboxCms
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}'), Rails.root.join('app', 'inputs', '{**}'), Rails.root.join('lib')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_support.escape_html_entities_in_json = true
    config.active_record.raise_in_transactional_callbacks = true
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.assets.initialize_on_precompile = false
    config.assets.raise_runtime_errors = false

    config.time_zone = 'Asia/Manila'

    config.encoding = 'utf-8'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.paperclip_defaults = {
  		:storage => :s3,
      :s3_host_name => 's3-ap-southeast-1.amazonaws.com',
  		:s3_credentials => {
  			:bucket            => ENV['S3_BUCKET_NAME'],
  			:access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  			:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  		}
  	}
  end
end
