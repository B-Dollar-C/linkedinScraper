Rails.application.routes.draw do
 namespace :api, defaults: {format: 'json'} do
    namespace :v1 do 
      get 'basic_data/profile', to: 'basic_data#profile'
    end
  end
end
