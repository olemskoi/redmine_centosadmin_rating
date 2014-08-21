resources :issues, only: [] do
  resources :staff_ratings, only: :new
end
resources :users, only: [] do
  resources :staff_ratings, only: :new
end
resources :projects, only: [] do
  resources :staff_ratings, only: :index
end
resources :staff_ratings
