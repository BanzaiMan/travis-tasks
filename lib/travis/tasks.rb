require 'bundler/setup'
require 'gh'
require 'travis'
require 'core_ext/module/load_constants'

$stdout.sync = true

Sidekiq.configure_server do |config|
  config.redis = {
    :url       => Travis.config.redis.url,
    :namespace => Travis.config.sidekiq.namespace
  }
  config.logger = nil unless Travis.config.log_level == :debug
end

Travis.config.update_periodically

Travis::Exceptions::Reporter.start
Travis::Notification.setup
Travis::Mailer.setup
Travis::Addons.register

# Travis::Memory.new(:tasks).report_periodically if Travis.env == 'production'
# NewRelic.start if File.exists?('config/newrelic.yml')


