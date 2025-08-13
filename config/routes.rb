Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users, controllers: { registrations: 'custom_devise/registrations' }

  namespace :users, path: '', as: '' do
    resource :profile, only: [:show, :edit, :update], shallow: true
    # get :receipts, to 'some#user_receipts'
  end

  resources :users, only: [] do
    resources :indications, only: [], module: 'users' do
      collection do
        # обнуление счетчика
        get :new_reset_electricity_meter
        post :create_reset_electricity_meter
      end
    end
  end

  resources :tariffs, only: :index

  # удалить :index когда будет ручка показаний
  resources :receipts, only: [:index, :show] do
    get :download, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :receipts, only: :create
      resources :indications, only: :show
    end
  end

  resources :indications, only: [:index, :new, :create, :show] do
    member do
      get :calculate
    end

    collection do
      # создание показаний месяца
      get :new_collective
      post :create_collective
      get :calculate_collective
    end
  end
end
