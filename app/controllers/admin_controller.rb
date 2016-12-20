require 'sidekiq/api'
class AdminController < ApplicationController
  protect_from_forgery with: :exception

  def index
    UpdateDataJob.perform_later if Delayed::Job.all.none? {|job| !!(job.handler =~ /UpdateDataJob/) }
    @schedules = Delayed::Job.all
  end

  def new
    create_session unless session[:user_id]
    @user = User.new
  end

  def create
    @user = User.new(whitelisted)
    if @user.save
      sign_in(@user)
      redirect_to users_path
    else
      flash.now[:danger] = "Something went wrong signing up"
      render :new
    end
  end

  private

    def whitelisted

      params.require(:user).permit(
                                    :email,
                                    :password,
                                    :password_confirmation,
                                  )
    end

end
