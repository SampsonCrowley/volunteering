require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Odata
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job

    config.after_initialize do
      if ActiveRecord::Base.connection.table_exists? 'delayed_jobs'
        UpdateDataJob.perform_later if Delayed::Job.all.none? {|job| !!(job.handler =~ /UpdateDataJob/) }
      end
    end
  end
end
