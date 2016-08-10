Rails.application.routes.draw do

  scope :module => 'buttercms' do
    get '/categories/:slug' => 'categories#show', :as => :buttercms_category
    get '/author/:slug' => 'authors#show', :as => :buttercms_author

    get '/blog/rss' => 'feeds#rss', :format => 'rss', :as => :buttercms_blog_rss
    get '/blog/atom' => 'feeds#atom', :format => 'atom', :as => :buttercms_blog_atom
    get '/blog/sitemap.xml' => 'feeds#sitemap', :format => 'xml', :as => :buttercms_blog_sitemap

    get '/blog(/page/:page)' => 'posts#index', :defaults => {:page => 1}, :as => :buttercms_blog
    get '/blog/:slug' => 'posts#show', :as => :buttercms_post
  end

  apipie
  resource :wechat, only: [:show, :create]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'site#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'site/aboutus' => 'site#about'
  get 'site/contactus' => 'site#contact'
  get 'site/privacy' => 'site#privacy'
  get 'site/career' => 'site#career'

  get 'apps/index' => 'apps#index'

  match 'users/sign_in' => 'users#login', via: [:get, :post]

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :agents do
    collection do
      post 'call'
      get 'search'
      get 'asearch'
      get 'intro'
    end
    resources :comments
  end
  resources :users do
    collection do
      post 'sms'
      get  'logout'
      get  'check_user'
      get  'check_mobile'
      get  'check_code'
      get  'reset'
      put  'reset'
    end
    resources :agents
  end

  resources :helper do
  end

  resources :tips do
    member do
      get 'download'
    end
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  namespace :api, format: 'json' do
    namespace :v1 do
      resources :users do
        get 'check_code', on: :collection
      end
      resources :agents
      resources :customers
      resources :tips
      resources :comments
    end
  end
  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
