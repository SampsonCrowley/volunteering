require 'sidekiq/api'
class StatesController < ApplicationController
  def index
    p Sidekiq::Queue.new("update_data").size
    p Sidekiq::ProcessSet.new.first['busy']
    p Sidekiq::ProcessSet.new
    p Sidekiq::ScheduledSet.new.any? {|scheduled| scheduled.queue == "update_data" }
    @results = StateStat.all.map {|state| [state.state, state.metrics]}
  end
end
