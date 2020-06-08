require 'rails_helper'
require 'faker'

RSpec.describe ProfilesController, type: :controller do

  let(:user) { Fabricate.create(:user) }

  describe 'GET #show' do
    context 'without sign in user' do
      it 'should redirect to sign in path' do
        get :show
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context 'with sign in user' do
      before { sign_in(user) }

      it 'should render template' do
        get :show
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #edit' do
    before { sign_in(user) }

    it 'should render template' do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    before { sign_in(user) }

    it 'should update user with the valid username' do
      username = 'abc123'
      put :update, params: { user: { username: username } }

      expect(response).to redirect_to(profile_path)
      expect(flash[:success]).to eq('Profile updated successfully')
    end

    it 'should update user with the valid password' do
      new_password = Faker::Internet::password
      put :update, params: { user: { password: new_password, password_confirmation: new_password } }
      user.reload
      expect(user.authenticate(new_password)).to eq user
      expect(response).to redirect_to(profile_path)
      expect(flash[:success]).to eq('Profile updated successfully')
    end

    it 'should not update user with invalid username' do
      username = 'abc1'
      put :update, params: { user: { username: username } }

      expect(response).to render_template(:edit)
    end

    it 'should not update user with invalid password' do
      password = 'abc123'
      put :update, params: { user: { password: password, password_confirmation: password } }

      expect(response).to render_template(:edit)
    end

    it 'should not update user when password and password confirmation does not match' do
      put :update, params: { user: { password: Faker::Internet::password, password_confirmation: Faker::Internet::password } }

      expect(response).to render_template(:edit)
    end
  end
end
