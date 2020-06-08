require 'rails_helper'
require 'faker'

RSpec.describe Users::PasswordsController, type: :controller do

  let(:user) { Fabricate.create(:user) }

  describe 'GET #new' do
    subject { get :new }

    it 'should render template' do
      expect(subject).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with existing email' do

      it 'should send reset password instructions' do
        post :create, params: { user: { email: user.email } }
        user.reload
        expect(user.reset_password_token).to be_present
        expect(user.reset_password_sent_at).to be_present
        expect(flash[:success]).to eq('Check email for further instructions')
        expect(response).to redirect_to(new_password_path)
      end
    end

    context 'with invalid email' do
      it 'should not take invalid email' do
        post :create, params: { user: { email: 'john@example.com' } }
        expect(flash[:error]).to eq('Record not found')
      end
    end
  end

  describe 'GET #edit' do
    before { post :create, params: { user: { email: user.email } } }

    it 'should render template with correct reset password token' do
      user.reload
      get :edit, params: { token: user.reset_password_token }
      expect(response).to render_template(:edit)
    end

    it 'should throw error with invalid reset password token' do
      get :edit, params: { token: Faker::Internet::password }
      expect(response).to redirect_to(new_password_path)
      expect(flash[:error]).to eq('Invalid forgot password url')
    end

    it 'should throw error with invalid reset password link' do
      user.reload
      user.reset_password_sent_at = Constant::RESET_TOKEN_EXPIRES_IN.hours.ago
      user.save!
      get :edit, params: { token: user.reset_password_token }
      expect(response).to redirect_to(new_password_path)
      expect(flash[:error]).to eq('Reset password token has been expired')
    end
  end

  describe 'PUT #update' do
    context 'with valid forget password link' do
      before do
        post :create, params: { user: { email: user.email } }
      end

      it 'should change the password' do
        put :update, params: params
        expect(flash[:success]).to eq('Password updated succesfully')
        expect(response).to redirect_to(sign_in_path)
      end

      it "should not change password when password and password_confirmation doesn't match" do
        invalid_params = params
        invalid_params[:user][:password] = Faker::Internet::password
        invalid_params[:user][:password_confirmation] = Faker::Internet::password
        post :update, params: invalid_params

        expect(response).to render_template(:edit)
      end
    end

    context 'with invalid forget password link' do

      it 'should throw error with invalid reset password link' do
        invalid_params = params
        invalid_params[:token] = Faker::Internet::password
        put :update, params: invalid_params
        expect(response).to redirect_to(new_password_path)
        expect(flash[:error]).to eq('Invalid forgot password url')
      end
    end
  end

  def params
    new_password = Faker::Internet::password
    user.reload
    { token: user.reset_password_token, user: { password: new_password, password_confirmation: new_password } }
  end
end
