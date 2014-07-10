resources :issues, only: [] do
  resources :ratings, only: [:new, :create], controller: :centos_ratings
end
resources :users, only: [] do
  resources :ratings, only: [:new, :create], controller: :centos_ratings
end
resources :ratings, only: [:show, :destroy], controller: :centos_ratings
