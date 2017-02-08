Rails.application.routes.draw do
  root "submissions#new"

  get "/submissions", to: "submissions#new"
  resources :submissions, only: [:new, :create]
  get "/submissions/thank_you", to: "submissions#thank_you"
  get "/submissions/closed", to: "submissions#closed"
  get "/submissions/preparation", to: "submissions#preparation"

  devise_for :users, skip: [:passwords, :registrations],
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get "/admin", to: "submission_filters#valid", path: :admin

  scope "/admin" do
    get "/submission_filters/valid", to: "submission_filters#valid"
    get "/submission_filters/rejected", to: "submission_filters#rejected"
    get "/submission_filters/to_rate", to: "submission_filters#to_rate"
    get "/submission_filters/results", to: "submission_filters#results"

    get "/csv/download_accepted", to: "csv#download_accepted"
    get "/csv/download_waitlist", to: "csv#download_waitlist"

    resources :submissions, only: :show do
      resource :rate, only: :create
      resources :comments, only: :create
    end

    get "/settings/", to: "settings#index"
    put "/settings/update", to: "settings#update"

    resources :questions, only: [:index, :new, :create, :destroy]
  end
end
