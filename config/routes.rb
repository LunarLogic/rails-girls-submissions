Rails.application.routes.draw do
  root "submissions#new"

  get "/submissions", to: "submissions#new"
  resources :submissions, only: [:new, :create]
  get "/submissions/confirm_invitation", to: "submissions#confirm_invitation"
  get "/submissions/thank_you", to: "submissions#thank_you"
  get "/submissions/closed", to: "submissions#closed"
  get "/submissions/preparation", to: "submissions#preparation"

  devise_for :users, skip: [:passwords, :registrations],
                     controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  scope "/admin" do
    get "/", to: "submission_filters#valid", as: :admin
    get "/submissions/valid", to: "submission_filters#valid"
    get "/submissions/rejected", to: "submission_filters#rejected"
    get "/submissions/to_rate", to: "submission_filters#to_rate"
    get "/submissions/results", to: "submission_filters#results"
    get "/submissions/participants", to: "submission_filters#participants"

    get "/csv/participants", to: "csv#participants"

    post "/send_invitation_emails", to: "mailings#send_invitation_emails"

    get "/submissions/:filter/:id", to: "submissions#show", as: :submission
    scope "/submissions/:filter/:submission_id" do
      resource :rate, only: :create
      resources :comments, only: :create
    end

    get "/settings/", to: "settings#index"
    put "/settings/update", to: "settings#update"

    resources :questions, only: [:index, :new, :create, :destroy]
    authenticate :user do
      match "/background_jobs" => DelayedJobWeb, :anchor => false, :via => [:get, :post],
            as: :background_jobs
    end
  end

  get "/pages/*id" => 'pages#show', as: :page, format: false
end
