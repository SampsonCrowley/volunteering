require 'sidekiq/api'
class StatesController < ApplicationController
  def index
    @results = StateStat.all.map {|state| [state.state, state.metrics]}
  end

  def new
    UpdateDataJob.perform_later
    redirect_to :index
  end
end
