class StatesController < ApplicationController
  skip_before_action :authenticate
  def index
    @results = StateStat.all.map {|state| [state.state, state.metrics]}
  end
end
