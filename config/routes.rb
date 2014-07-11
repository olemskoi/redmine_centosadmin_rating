resources :issues, only: [] do
  resources :centos_ratings, only: [:new]
end
resources :users, only: [] do
  resources :centos_ratings, only: [:new]
end
resources :centos_ratings
