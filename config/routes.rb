Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users, controllers: { registrations: 'custom_devise/registrations' }

  namespace :users, path: '', as: '' do
    resource :profile, only: [:show, :edit, :update], shallow: true
    # get :receipts, to 'some#user_receipts'
  end

  resources :tariffs, only: :index

  # удалить :index когда будет ручка показаний
  resources :receipts, only: [:index] do
    get :download, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :receipts, only: :create
      resources :indications, only: :show
    end
  end

  resources :indications, only: [:index, :new, :create, :show] do
    collection do
      get :new_collective
      post :create_collective
    end
  end
end
