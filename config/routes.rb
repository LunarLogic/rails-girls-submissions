Rails.application.routes.draw do
  get "/submissions/thank_you", to: "submissions#thank_you"
  get "/submissions/", to: "submissions#all"
  get "/submissions/rated", to: "submissions#rated"
  get "/submissions/to_rate", to: "submissions#to_rate"
  get "/submissions/rejected", to: "submissions#rejected"
  get "/submissions/results", to: "submissions#results"
  get "/submissions/closed", to: "submissions#closed"
  get "/submissions/preparation", to: "submissions#preparation"
  get "/settings/", to: "settings#index"
  put "/settings/update", to: "settings#update"

  get "/csv/download_accepted", to: "csv#download_accepted"
  get "/csv/download_waitlist", to: "csv#download_waitlist"
  get "/csv/download_unaccepted", to: "csv#download_unaccepted"

  devise_for :users, skip: [:passwords, :registrations], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'submissions#new'

  get "/admin", to: "submissions#all", path: :admin

  resources :submissions, except: [:edit, :update, :index] do
    resource :rate, only: :create
    resources :comments, only: :create
  end
end
