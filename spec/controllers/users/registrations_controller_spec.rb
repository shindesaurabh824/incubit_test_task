require 'rails_helper'
require 'faker'

RSpec.describe Users::RegistrationsController, type: :controller do

  describe 'GET #new' do
    subject { get :new }

    it 'should render template' do
      expect(subject).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      subject { post :create, params: params }

      it { expect { subject }.to change(User, :count).by(1) }

      it 'should create user' do
        subject
        expect(response).to redirect_to(profile_path)
        expect(flash[:success]).to eq('Welcome to Incubit ...')
      end
    end

    context 'with invalid parameters' do
      it 'should not take invalid email' do
        invalid_params = params
        invalid_params[:user][:email] = 'base122@amcom@com'
        expect { post :create, params: invalid_params }.to change { User.count }.by(0)

        expect(response).to render_template(:new)
      end

      it "should not change password when password and password_confirmation doesn't match" do
        invalid_params = params
        invalid_params[:user][:password] = Faker::Internet::password
        invalid_params[:user][:password_confirmation] = Faker::Internet::password
        expect { post :create, params: invalid_params }.to change { User.count }.by(0)

        expect(response).to render_template(:new)
      end

      it 'should not create user with existing email' do
        post :create, params: params

        invalid_params = params
        invalid_params[:user][:email] = User.last.email

        expect { post :create, params: invalid_params }.to change { User.count }.by(0)
        expect(response).to render_template(:new)
      end
    end
  end

  def params
    password = Faker::Internet::password
    { user: { email: Faker::Internet::email, password: password, password_confirmation: password } }
  end
end