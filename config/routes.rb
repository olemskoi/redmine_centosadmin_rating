resources :issues, only: [] do
  resources :centos_ratings, only: [:new, :create]
end
resources :users, only: [] do
  resources :centos_ratings, only: [:new, :create]
end
resources :centos_ratings, only: [:new, :create, :index, :show, :destroy]
