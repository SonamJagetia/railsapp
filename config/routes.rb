Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  root 'welcome#index'
  get 'mentors' => 'mentors#index'
  get 'mentors/:id' => 'mentors#show'
  get 'users/:id' => 'users#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end