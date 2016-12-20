require 'sidekiq/api'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
  Rails.application.config.after_initialize do
    UpdateDataJob.perform_later if Sidekiq::ScheduledSet.new.none? {|scheduled| scheduled.queue == "update_data" }
  end
end

# so one sidekiq can have 7 connections
Sidekiq.configure_server do |config|
  config.redis = { :size => 7 }
end
