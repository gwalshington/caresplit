require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Caresplit
  class Application < Rails::Application
    config.filter_parameters << :password
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
Raven.configure do |config|
  config.dsn = 'https://44ed172b33af48edb7716ffc8ae7a0e4:512cafa121a04f009107f375ce46f245@sentry.io/1524711'
end
