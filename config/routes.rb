Rails.application.routes.draw do
  
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about'
  get "search" => "searches#search"
  
  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers' 
  end
    resources :messages, only: [:create]
    resources :rooms, only: [:create,:show]
  
  resources :books do
    # resourceにすると、そのコントローラのidがリクエストに含まれなくなる。
    # favoritesのshowページが不要で、idの受け渡しも必要ないので、resourceとなる
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
end