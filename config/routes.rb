Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'home#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Clearance routes start
  resources :passwords, controller: "passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  post :send_verification_email, to: "users#send_verification_email"

  resources :users, controller: "users", only: [:create] do
    resources :purchased_products
    resource :password, controller: "passwords", only: [:edit, :update]
  end

  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"

  # Privacy information
  resource :support_tickets, only: %i[new create]
  resources :faq, only: %i[index]
  resource :privacy_policy, only: %i[show]
  resource :terms_of_service, only: %i[show]
  resource :cookie_policy, only: %i[show]

  resources :verifications, only: [:edit], param: :verification_token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # An example of using clearance to put route guarding in the routes level
  # These routes will not even be defined for users without super_admin role
  constraints Clearance::Constraints::SignedIn.new { |user| user.super_admin? } do
    namespace :admin do
      root 'dashboard#show'

      resources :products do
        resources :product_prices
      end

      resources :users do
        member do
          post :toggle_admin
          post :toggle_super_admin
          post :send_verification_email
        end
      end

      resources :support_tickets, only: %i[index] do
        member do
          post :assign_to_user
        end
      end

      resources :application_errors, only: %i[index]

      namespace :stripe do
        get 'products', to: 'products#index'
        get 'product/:id', to: 'products#show'
        post 'products', to: 'products#create'
        put 'products', to: 'products#update'
        get 'prices', to: 'prices#index'
        post 'prices', to: 'prices#create'
        put 'prices', to: 'prices#update'
      end
    end
  end

  # constraints Clearance::Constraints::SignedOut.new do
  #   root to: "marketing#index"
  # end
  # Clearance routes end

  constraints Clearance::Constraints::SignedIn.new do
    namespace :stripe do
      post 'billing_portal_sessions', to: 'billing_portal_sessions#create'
    end
    post 'update_passage_progress', to: 'passage_progresses#update_progress', as: :update_passage_progress
  end

  if Rails.env.development?
    mount GoodJob::Engine => 'good_job'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # For Stripe webhooks
  namespace :stripe do
    post 'webhooks', to: 'webhooks#create'
  end

  resources :topics, param: :name do
    resources :passage_reader, controller: 'topics/passage_reader'
    resources :passage_writer, controller: 'topics/passage_writer'
  end

  # get 'passages/:topic_name', to: 'passages#get_by_topic', as: :passages_by_topic
  get 'passages/by_difficulty/:difficulty_name', to: 'passages#by_difficulty', as: :passages_by_difficulty
  get 'passages/by_difficulty/:difficulty_name/passage_writer/:passage_name', to: 'passages#passage_writer', as: :passage_writer
  get 'passages/in_progress', to: 'passages#in_progress', as: :passages_in_progress
  resources :passages do
    member do
      post 'translate'
      get 'translations'
    end
  end

  resources :pronunciations, param: :text, only: %i[show]

  resource :checkout, only: %i[new show]
  resources :products, only: %i[index show]
end
