Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :reports, :only => [:index, :show] do
      collection do
        get :shipped_weekly
        post :shipped_weekly
      end
    end
  end
end
