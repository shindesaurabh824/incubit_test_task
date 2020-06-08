class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :user_logged_in?
  before_action :authenticate_user!

  rescue_from StandardError do |error|
    render_error(t('errors.internal_server'))
  end

  rescue_from ActiveRecord::RecordNotFound do |error|
    render_error(t('errors.record_not_found'))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_logged_in?
    current_user.present?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  private

  def authenticate_user!
    redirect_to sign_in_path unless user_logged_in?
  end

  def render_error(message)
    flash[:error] = message
    redirect_to request.referrer
  end
end
