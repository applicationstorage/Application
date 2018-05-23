Rails.application.routes.draw do

  mount EpiCas::Engine, at: "/"
  devise_for :users
  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  root to: "admin_summaries#index"

  resources :inventories
  resources :items
  resources :disposeds
  resources :research_projects
  resources :loans
  resources :loan_histories
  resources :admin_summaries
  resources :request_baskets
  resources :pages
  #get 'research_projects/:user_email/project', to: "research_projects#project", as: :project_research_project

  get :home, to: "pages#home", as: :home
  get :departmental_devices, to: "categories#departmental_devices", as: :departmental_devices
  get :laptops, to: "categories#laptops", as: :laptops
  get :tablets, to: "categories#tablets", as: :tablets
  get :cameras_recorders, to: "categories#cameras_recorders", as: :cameras_recorders
  get :audio_devices, to: "categories#audio_devices", as: :audio_devices
  get :misc_devices, to: "categories#misc_devices", as: :misc_devices
  get :loanHistory, to: "pages#loanHistory", as: :loanHistory

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
