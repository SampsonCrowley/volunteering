# require 'sidekiq/api'
#
# Sidekiq.configure_client do |config|
#   Rails.application.config.after_initialize do
#     UpdateDataJob.perform_later if Sidekiq::ScheduledSet.new.none? {|scheduled| scheduled.queue == "update_data" }
#   end
# end
