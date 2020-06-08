require 'rails_helper'
require 'faker'

RSpec.describe Users::SessionsController, type: :controller do

  let(:user) { Fabricate.create(:user) }

  describe 'GET #new' do
    subject { get :new }

    it 'should render template' do
      expect(subject).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      subject do
        post :create, params: { user: { email: user.email,
                                password: user.password } }
      end

      it 'should login' do
        subject
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(profile_path)
        expect(flash[:success]).to eq('Sign in successfully')
      end
    end

    context 'with invalid parameters' do
      it 'with incorrect email' do
        invalid_params = params
        params[:user][:email] = Faker::Internet::email
        post :create, params: invalid_params

        expect(response).to redirect_to(sign_in_path)
        expect(flash[:error]).to eq('Incorrect email or password')
      end

      it 'with incorrect password' do
        invalid_params = params
        params[:user][:password] = Faker::Internet::password
        post :create, params: invalid_params

        expect(response).to redirect_to(sign_in_path)
        expect(flash[:error]).to eq('Incorrect email or password')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    it 'should logout' do
      expect(session[:user_id]).not_to be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(subject).to redirect_to (sign_in_path)
    end
  end

  def params
    { user: { email: Faker::Internet::email, password: user.password } }
  end
end
