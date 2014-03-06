# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :projects do
 resources :standup_reports do
  collection do
   get :index
   get :home
   get :verify
   get :report
  end
 end
end

match 'project/:project_id/standup_reports', :to => 'standup_project_settings#standup_setting', :via => :post

match 'project/:project_id/standup_reports', :to => 'standup_reports#index', :via => :get

match 'project/:project_id/standup_reports/tooltip', :to => 'standup_reports#tooltip'