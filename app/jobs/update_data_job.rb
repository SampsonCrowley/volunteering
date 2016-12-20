require 'sidekiq/api'

class UpdateDataJob < ApplicationJob
  queue_as :update_data

  def perform(*args)
    client = Soda.new
    client.search
  end

  after_perform do
    if Sidekiq::ScheduledSet.new.none? {|scheduled| scheduled.queue == "update_data" }
      UpdateDataJob.set(wait: 60.minutes).perform_later if Delayed::Job.all.none? {|job| !!(job.handler =~ /UpdateDataJob/) }
    end
  end
end
