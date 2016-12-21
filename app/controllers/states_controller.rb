class StatesController < ApplicationController
  skip_before_action :authenticate

  def index
    unless params[:state]
      @results = StateStat.all.map {|state| [state.state, state.main_mt]}
    else
      redirect_to state_path(params[:state])
    end
    @states = state_names
  end

  def show
    @state = params[:id]
    @states = state_names
    soda = Soda.new
    @results = soda.detailed(params[:id])
  end

  def state_names
    %w(Alaska Alabama Arkansas  Arizona California Colorado Connecticut District\ of\ Columbia Delaware Florida Georgia Hawaii Iowa Idaho Illinois Indiana Kansas Kentucky Louisiana Massachusetts Maryland Maine Michigan Minnesota Missouri Mississippi Montana North\ Carolina North\ Dakota Nebraska New\ Hampshire New\ Jersey New\ Mexico Nevada New\ York Ohio Oklahoma Oregon Pennsylvania Rhode\ Island South\ Carolina South\ Dakota Tennessee Texas Utah Virginia Vermont Washington Wisconsin West\ Virginia Wyoming)
  end
end
