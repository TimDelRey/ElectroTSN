Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users, controllers: { registrations: 'custom_devise/registrations' }

  namespace :users, path: '', as: '' do
    resource :profile, only: [:show, :edit, :update], shallow: true
  end

  resources :tariffs, only: [:index, :show]
end
