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
        end
        resources :parameters
      end
    end
  end

  root 'home#index'

end