require 'resque/server'

Rails.application.routes.draw do

  https_constraint = (Rails.env.production? ? {protocol: 'https://'} : {})
  http_catchall    = (Rails.env.production? ? {protocol: 'http://'}  : -> (params, request) {false})

  namespace :api, path: "api", constraints: https_constraint, defaults: { format: 'json' } do
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :devices do
        resources :device_settings, path: 'settings', only: :index
        resources :metrics do
          resources :measures
          resources :alerts
        end
        resources :parameters
        resources :strips, only: [:create, :show]
      end
      post :registration,  to: 'registration#create'
      post :login,         to: 'login#login'
      post :push_update,   to: 'push#update_info'
    end
  end

  namespace :admin, path: "pastouch", constraints: https_constraint do
    root 'devices#index', as: 'root'
    resources :devices, path: '/' do
      member do
        get ':metric', to: 'metrics#show', metric: /(PH|WTEMP|ATEMP|AHUM|LCYC|UCYC|NO2|NO3|NH4|GH|KH)/, as: 'metric'
        resources :device_settings
      end
      get :log, on: :member
    end
  end

  post :sign, to: "signing#sign"
  get :form, to: "signing#form"

  mount Resque::Server, at: '/jobs', as: 'jobs'

  root 'home#index'

end