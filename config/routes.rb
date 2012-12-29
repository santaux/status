Status::Application.routes.draw do
  resources :namespaces do
    resources :projects do
      resources :reports
    end
  end

  root :to => "namespaces#index"
end
