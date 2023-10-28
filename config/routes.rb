Rails.application.routes.draw do
 namespace :api, defaults: {format: 'json'} do
    namespace :v1 do 
      post 'basic_data/profile', to: 'basic_data#profile'
      get 'basic_data/login', to: 'basic_data#login'
      post 'basic_data/register', to: 'basic_data#register'
    end
  end
end
