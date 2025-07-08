Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users, controllers: { registrations: 'custom_devise/registrations' }

  namespace :users, path: '', as: '' do
    resource :profile, only: [:show, :edit, :update], shallow: true
    # get :receipts, to 'some#user_receipts'
  end

  resources :tariffs, only: :index

  # resources :receipts, only: [:index, :show] do
  #   member do
  #     get :download
  #   end
  # end
end
