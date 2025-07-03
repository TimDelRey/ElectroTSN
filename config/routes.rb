Rails.application.routes.draw do
  namespace :user do
    get "profile/show"
    get "profile/edit"
    get "profile/update"
  end
  # get "profile/show"
  # get "profile/edit"
  # get "profile/update"
  root to: 'welcome#index'

  devise_for :users, controllers: { registrations: 'custom_devise/registrations' }

  resource :profile, only: [:show, :edit, :update]
end
