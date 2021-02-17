Rails.application.routes.draw do
  # For details on the DSL available within this ile, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/register', to: 'devices#create'
    post '/alive', to: 'devices#alive'
    post '/report', to: 'devices#report'
    patch '/terminate', to: 'devices#update'
  end
end
