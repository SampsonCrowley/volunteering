require 'sidekiq/api'
class AdminController < ApplicationController
  before_action :authenticate, except: [:new, :create]
  protect_from_forgery with: :exception

  def index
    UpdateDataJob.perform_later if Sidekiq::ScheduledSet.new.none? {|scheduled| scheduled.queue == "update_data" }
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

    def authenticate
      unless signed_in_user?
        flash[:danger] = ["Please sign in"]
        redirect_to states_path
      end
    end

    def create_session
      user = User.find_by_token(cookies[:token]) if cookies[:token]
      sign_in(user) if user
    end

    def current_user
      create_session unless session[:user_id]
      @current_user ||= User.find_by_id(decrypt(session[:user_id])) if session[:user_id]
    end
    helper_method :current_user

    def sign_in(user, remember = false)
      reset_session
      if remember
        set_token(user)
      end
      session[:user_id] = user.id
      @current_user = user
    end

    def set_token(user)
      user.regenerate_auth_token
      cookies[:token] = user.token
    end

    def sign_out
      current_user.destroy_token
      @current_user = nil
      session.delete(:user_id)
      cookies.delete(:token)
      reset_session
    end


    def signed_in_user?
      !!current_user
    end
    helper_method :signed_in_user?

    def whitelisted_user_params
      params.require(:user).permit(:email,
                                   :password,
                                   :password_confirmation)
    end

end
