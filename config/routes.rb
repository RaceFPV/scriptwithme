Scriptwithme::Application.routes.draw do
  
  #website root
  root to: 'scenes#index'
  
  #routes for starting a scene
  match  '/start', to: 'sessions#new', via: 'get', as: :start
  match  '/start', to: 'sessions#create', via: 'post'
  
  #routes for joining an existing scene via invite
  match  '/join/:scene_id', to: 'sessions#join', via: 'get', as: :join
  match  '/join/:scene_id', to: 'sessions#joincreate', via: 'post'
  
  #routes while in a scene
  match  '/scenes/:id/quit', to: 'sessions#destroy', via: 'delete', as: :end_scene
  match  '/scenes/start-new-scene', to: 'scenes#start_new_scene', via: 'post', as: :start_new_scene
  match  '/scenes/:id/save', to: 'scenes#save_name', via: 'put', as: :save_scene_name
  match  '/scenes/:id/save', to: 'scenes#savescene', via: 'post', as: :savescene
  match  '/scenes/saved/:id', to: 'scenes#savedscene', via: 'get', as: :savedscene
  match  '/scenes/:id/signup', to: 'users#createfromscene', via: 'post', as: :create_from_scene
  match  '/scenes/:id/savetitle', to: 'scenes#savescenetitle', via: 'post', as: :save_scene_title
  match  '/scenes/:id/unsave', to: 'scenes#unsave', via: 'delete', as: :unsavescene
  
  
  #routes for the scene side chat
  match  '/scenes/:id/sidechat', to: 'sidechats#show', via: 'get', as: :sidechat
  match  '/scenes/:id/sidechat', to: 'sidechats#submit', via: 'post', as: :sidechatsend
  
  #routes for connect and queue pages
  match  '/connect/random-connect', to: 'connect#random_connect', via: 'get', as: :random_connect
  match  '/connect/waiting-partner', to: 'connect#waiting_random_partner', via: 'post', as: :waiting_random_partner
  match  '/connect/giveup', to: 'connect#giveup', via: 'get', as: :giveup
  match  '/scenes/:id/waiting', to: 'connect#waiting', via: 'get', as: :waiting
  
  #routes for messages using faye/private_pub
  match  '/messages/:id/leftscene', to: 'messages#leftscene', via: 'get', as: :leftscene
  match  '/messages/:id/atscene', to: 'messages#atscene', via: 'get', as: :atscene
  match  '/messages/:id/info', to: 'messages#info', via: 'post', as: :info
  match  '/messages/:id/leave', to: 'messages#leave', via: 'get', as: :leave
  match  '/messages/:id', to: 'messages#info', via: 'post'
  match  '/messages/:id/drop_a_line', to: 'messages#drop_a_line', via: 'post', as: :drop_a_line
  match  '/messages/:id/change-name', to: 'messages#change_name', via: 'post', as: :change_name
  match  '/messages/:id/end', to: 'messages#endscene', via: 'get', as: :endscene
  match  '/messages/:id/delete/:line', to: 'messages#deleteline', via: 'get', as: :deleteline
  
  #routes for other pages
  match  '/users/:id', to: 'users#show', via: 'get', as: :scene_scripts
  match  '/users/:id/profile', to: 'users#showprofile', via: 'get', as: :user_profile
  match  '/users/:id/friends', to: 'users#friends', via: 'get', as: :friends_user
  match  '/users/:id/saved', to: 'users#saved', via: 'get', as: :saved_user
  match  '/users/:id/home', to: 'users#home', via: 'get', as: :home
  match  '/users/:id/rating/:rating', to: 'users#rating', via: 'get', as: :rating
  match  '/users/:id/admin', to: 'users#admin', via: 'get', as: :admin_user
  match  '/users/:id/delete_user/:delete', to: 'users#delete_user', via: 'get', as: :delete_user
  match  '/users/:id/delete_scene/:delete', to: 'users#delete_scene', via: 'get', as: :delete_scene
  match  '/users/:id/delete_starter/:delete', to: 'users#delete_starter', via: 'get', as: :delete_starter
  match  '/users/:id/add_starter', to: 'users#addstarter', via: 'post', as: :add_starter
  match  '/users/:id/adminify/:user', to: 'users#adminify', via: 'get', as: :adminify
  match  '/users/:id/noadmin/:user', to: 'users#noadmin', via: 'get', as: :noadmin
  match  '/users/:id/starters', to: 'users#starters', via: 'get', as: :starters
  match  '/users/:id/starters/save', to: 'users#savestarter', via: 'post', as: :savestarter
  match  '/users/:id/addfriend/', to: 'users#addfriend', via: 'post', as: :addfriend
  match  '/users/:id/sendmessage/', to: 'users#sendmessage', via: 'post', as: :sendmessage
  match  '/users/:id/message/:messageid', to: 'users#message', via: 'get', as: :message
  match  '/users/:id/messages', to: 'users#messages', via: 'get', as: :messages
  match  '/users/:id/sendalert', to: 'users#sendalert', via: 'post', as: :sendalert
  
  #generate routes for users
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: 'sessions#failure', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post, :delete]
  
  #generate default routes for users
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :identities
  
  #generate routes for watch
  match '/users/:id/live', to: 'live#index', via: 'get', as: :live_index
  match '/live/:id', to: 'live#show', via: 'get', as: :live
  match '/live/:id/leave', to: 'live#leave', via: 'get', as: :leave_live
  
  #generate default routes for /scenes
  resources :scenes, param: :id do
    collection do
      get :giveup, :as => :giveup
    end
  end
end
