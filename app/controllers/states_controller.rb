require 'sidekiq/api'
class StatesController < ApplicationController
  def index
    @results = StateStat.all.map {|state| [state.state, state.metrics]}
  end
end
