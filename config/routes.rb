Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'profiles#show'

  scope :users, module: 'users' do
    get :sign_up, to: 'registrations#new'
    post :sign_up, to: 'registrations#create'
    get :sign_in, to: 'sessions#new'
    post :sign_in, to: 'sessions#create'
    delete :sign_out, to: 'sessions#destroy'
  end

  resource :profile, only: %i[show edit update]

  get '*path', to: redirect('/')
end
