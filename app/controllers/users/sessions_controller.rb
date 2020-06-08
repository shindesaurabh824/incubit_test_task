# frozen_string_literal: true

# Users sessions controller
class Users::SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: %i[create]

  def new; end

  def create
    if @user&.authenticate?(user_params(:password))
      sign_in(@user)
      flash[:success] = t('controller.sessions.signed_in')
      redirect_to profile_path
    else
      flash[:error] = t('controller.sessions.incorrect_credentials')
      redirect_to sign_in_path
    end
  end

  def destroy
    sign_out
    flash[:success] = t('controller.sessions.signed_out')
    redirect_to sign_in_path
  end

  private

  def user_params(attribute)
    params.dig(:user, attribute)
  end

  def sign_out
    session[:user_id] = nil
  end

  def set_user
    @user = User.find_by_email(user_params(:email))
  end
end
