require 'resque/server'

Rails.application.routes.draw do

  https_constraint = (Rails.env.production? ? {protocol: 'https://'} : {})
  http_catchall    = (Rails.env.production? ? {protocol: 'http://'}  : -> (params, request) {false})

  namespace :api, path: "api", constraints: https_constraint do
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :devices do
        resources :metrics do
          resources :measures
          resources :alerts
        end
        resources :parameters
      end
    end
  end

  namespace :demo, path: "demo", constraints: https_constraint do
    root 'devices#index', as: 'root'
    # get '/:device_key'        => 'devices#show',  as: 'device'
    # get '/:devices_key/logs'  => 'devices#logs',  as: 'device_log'
    resources :devices, path: '/' do
      member do
        get ':metric', to: 'metrics#show', metric: /(PH|WTEMP|ATEMP|AHUM|LCYC|UCYC|NO2|NO3|NH4|GH|KH)/, as: 'metric'
      end
      get :log, on: :member
    end
  end

  mount Resque::Server, at: '/jobs', as: 'jobs'

  root 'home#index'

end