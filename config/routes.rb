Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users, controllers: { registrations: 'custom_devise/registrations' }

  namespace :users, path: '', as: '' do
    resource :profile, only: [:show, :edit, :update], shallow: true
  end

  resources :tariffs, only: :index

  # удалить :index когда будет ручка показаний
  resources :receipts, only: [:index, :show] do
    get :download, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :indications, only: [] do
        collection do
          get :show_person
          get :show_month_collective
        end
      end
      resources :receipts, only: [] do
        get :complete
      end
      resource :tariffs, only: [] do
        get :actual
      end
      resources :users, only: [:show]
    end
  end

  namespace :moderators do
    resources :indications, only: [:new, :create, :edit, :update, :show] do
      collection do
        get :new_collective
        post :create_collective
        post :confirm_month
        get :new_reset_electricity_meter
        post :create_reset_electricity_meter
      end
    end
  end
end
