# frozen_string_literal: true

# Users passwords controller
class Users::PasswordsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_user_by_email, only: :create
  before_action :find_user_by_reset_password_token, only: %i[edit update]
  before_action :check_reset_password_token_expiry, only: :edit

  def new; end

  def create
    if @user.create_reset_password_token
      @user.send_reset_password_email
      flash[:success] = t('controller.passwords.instruction')
      redirect_to new_password_path
    else
      flash[:error] = t('controller.passwords.instruction_sending_failed')
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('controller.passwords.updated')
      redirect_to sign_in_path
    else
      render :edit
    end
  end

  private

  def find_user_by_email
    email = params.dig(:user, :email)
    @user = User.find_by(email: email) if email
    return if @user
    flash[:error] = t('errors.record_not_found')
    redirect_to new_password_path
  end

  def find_user_by_reset_password_token
    token = params.dig(:user, :token) || params.dig(:token)
    @user = User.find_by(reset_password_token: token) if token
    return if @user
    flash[:error] = t('controller.passwords.invalid_url')
    redirect_to new_password_path
  end

  def check_reset_password_token_expiry
    return unless @user.reset_password_token_expired?
    flash[:error] = t('controller.passwords.token_expired')
    redirect_to new_password_path
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
          .merge(reset_password_token: nil, reset_password_sent_at: nil)
  end
end
