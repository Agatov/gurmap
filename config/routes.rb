Sale::Application.routes.draw do

  root :to => "places#index"

  match '/auth/:provider/callback', to: 'authentications#create'

  devise_for :accounts,
    path: 'accounts',
    path_names: {
      sign_up: :new,
      sign_in: :login,
      sign_out: :logout
    },
    controllers: { sessions: "account/auth/sessions", registrations: 'account/auth/registrations' }


  resources :users, only: [:show, :edit, :update] do
    post :set_phone, on: :collection
    post :confirm_phone, on: :collection
  end
  resources :authentications, only: [:create, :destroy]


  # На тест!!!
  resources :profile, only: [:index] do
    post :set_phone, on: :collection
    post :confirm_phone, on: :collection
  end

  resources :places, only: [:index, :show] do
    get :schedule, on: :member
    get :menu, on: :member
    get :contacts, on: :member
    get :preview, on: :member
  end

  resources :tags, only: [:index]

  resources :orders, only: [:create, :destroy]

  resources :pages, only: [] do
    get :about, on: :collection
    get :info, on: :collection
  end

  namespace :account do 
    resources :places do 
      get :schedule, on: :member
      get :tags, on: :member
      get :description, on: :member

      resources :photos, only: [:index, :create, :destroy]
    end

    resources :schedules
  end
end
