resources :issues, only: [] do
  resources :ratings, only: :new
end
resources :users, only: [] do
  resources :ratings, only: :new
end
resources :ratings
