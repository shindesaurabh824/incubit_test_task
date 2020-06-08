# frozen_string_literal: true

# Profiles controller
class ProfilesController < ApplicationController

  def show; end

  def edit; end

  def update
    if current_user.update(user_params)
      flash[:success] = t('controller.users.profile_updated')
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :username)
  end
end
