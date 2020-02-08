Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users do
    get :favorites, on: :member
  end

  # resources :users, only: [:index, :show] do
  #   get :favorites, on: :member
  # end
  resources :carts
  resources :orders

  resources :line_items do
    put 'decrease', on: :member
    put 'increase', on: :member
  end

  resources :products do
    resource :favorites, only: [:create, :destroy]
    get :who_bought, on: :member
  end

  resources :categories
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # resources :admin do
  #   get 'products', on: :member
  # end
  
  get 'inquiry/confirm' => 'inquiry#index' 
  get 'inquiry/thanks' => 'inquiry#index' 
  get 'inquiry' => 'inquiry#index'              # 入力画面
  post 'inquiry/confirm' => 'inquiry#confirm'   # 確認画面
  post 'inquiry/thanks' => 'inquiry#thanks'     # 送信完了画面



  get 'admin' => 'admin#index'
  get 'admin/products'
  get 'admin/users'
  get 'admin/categories'
  get 'admin/orders'

  get 'users/index'

  get 'orders/new'

  get 'store/index'
  # get 'products/index'
  # post 'products/new'
  # root 'products#index'
  post 'products/:id' => 'products#show'
  post 'categories/:id' => 'categories#show'

  root to: 'store#index', as: 'store'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
