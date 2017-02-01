Rails.application.routes.draw do
  root "submissions#new"
  get "/admin", to: "submission_filters#valid", path: :admin

  devise_for :users, skip: [:passwords, :registrations],
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get "/submission_filters/valid", to: "submission_filters#valid"
  get "/submission_filters/rejected", to: "submission_filters#rejected"
  get "/submission_filters/to_rate", to: "submission_filters#to_rate"
  get "/submission_filters/results", to: "submission_filters#results"

  get "/csv/download_accepted", to: "csv#download_accepted"
  get "/csv/download_waitlist", to: "csv#download_waitlist"
  get "/csv/download_unaccepted", to: "csv#download_unaccepted"

  get "/submissions/thank_you", to: "submissions#thank_you"
  get "/submissions/closed", to: "submissions#closed"
  get "/submissions/preparation", to: "submissions#preparation"

  get "/submissions", to: "submissions#new"
  resources :submissions, except: [:edit, :update, :index] do
    resource :rate, only: :create
    resources :comments, only: :create
  end

  resources :questions, only: [:index, :new, :create, :destroy]

  get "/settings/", to: "settings#index"
  put "/settings/update", to: "settings#update"
end
