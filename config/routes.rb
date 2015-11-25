require 'resque/server'

Rails.application.routes.draw do

  https_constraint = (Rails.env.production? ? {protocol: 'https://'} : {})
  http_catchall    = (Rails.env.production? ? {protocol: 'http://'}  : -> (params, request) {false})

  namespace :api, path: "api", constraints: https_constraint, defaults: { format: 'json' } do
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :devices do
        resources :device_settings, path: 'settings', only: [:index] do
          collection do
            post :bulk_update
          end
        end
        resources :metrics do
          resources :measures
          resources :alerts
        end
        resources :parameters
        resources :strips, only: [:create, :show]
        resources :log_entries, path: 'logs', only: [:create, :index]
        post :brain_upgrade, to: 'brain_upgrade#upgrade'
      end
      namespace :app, path: 'app' do
        post :registration,  to: 'registration#create'
        post :login,         to: 'login#create'
        post :push_update,   to: 'push#create'
      end
    end
  end

  namespace :admin, path: "pastouch", constraints: https_constraint do
    resources :devices do
      member do
        get ':metric', to: 'metrics#show', metric: /(PH|WTEMP|WVOL|ATEMP|AHUM|LCYC|UCYC|NO2|NO3|NH4|GH|KH)/, as: 'metric'
      end
      resources :device_settings do
        patch :prolong_date, to: 'device_settings#prolong_date', on: :member
      end
      resources :log_entries, path: 'logs', only: :index
      resources :device_permissions, path: 'owners'
    end
    resources :users
    root 'devices#index'
  end

  devise_for :users, class_name: 'Risebox::Core::User', path: "account", path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register' }

  namespace :account, path: "account", constraints: https_constraint do
    get :sso, to: "sso#sso"
  end

  post :sign, to: "signing#sign"
  get :form,  to: "signing#form"
  get :rollback,  to: "recovery#rollback"


  mount Resque::Server, at: '/jobs', as: 'jobs'

  root 'home#index'

end