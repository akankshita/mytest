ActionController::Routing::Routes.draw do |map|

  map.resources :support_tickets

  map.resources :app_configs
  
  map.resources :users

  map.resources :user_sessions

  map.resources :activity_logs

  map.resources :gas_uploads

  map.resources :disclosure_tasks

  map.resources :growth_metric_tasks

  map.resources :early_action_metric_tasks

  map.resources :significant_group_undertakings

  map.resources :report_other_fuels_tasks

  map.resources :conversion_factors

  map.resources :electricity_generating_credits_tasks

  map.resources :confirm_energy_supply_task

  map.resources :renewables

  map.resources :annual_reports

  map.resources :other_fuels

  map.resources :residual_emissions

  map.resources :calculation_check_tasks

  map.resources :emission_metrics_tasks

  map.resources :energy_metrics_tasks

  map.resources :reconfirmation_exemption_tasks

  map.resources :cca_exemptions

  map.resources :designated_changes

  map.resources :chart_test
  
  map.resources :meter_groups

  map.resources :meters

  map.resources :locations

  map.resources :electricity_configs  

  map.connect '/document_uploads/list', :controller => 'document_uploads', :action => 'list'

  map.resources :document_uploads

  map.resources :electricity_readings

  map.resources :electricity_uploads

  map.resources :gas_readings

  map.resources :users
  
  map.resources :carbon_plot, :singular => :carbon_plot_instance
  
  map.resources :home, :singular => :home_instance

  map.resources :source_manager, :singular => :source_manager_instance

  map.login "login", :controller => "user_sessions", :action => "new"

  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.send_data "send_data", :controller => "rest_api", :action => "send_data"



  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  
  map.usage_plot '/usage_plot', :controller => "usage_plot", :action => "index"
  
  map.trends_graph '/trends_graph', :controller => "trends_graph", :action => "index"
   
  map.status_graph '/status_graph', :controller => "status_graph", :action => "index"
  
  map.status_home '/status_home', :controller => "status_home", :action => "index"

  map.footprint_report_page '/footprint_report_page', :controller => "footprint_report_page", :action => "index"

  map.gas_summary '/gas_summary', :controller => "gas_summary", :action => "index"

  map.electricity_summary '/electricity_summary', :controller => "electricity_summary", :action => "index"

  map.gas_detail '/gas_detail', :controller => "gas_detail", :action => "index"

  map.electricity_detail '/electricity_detail', :controller => "electricity_detail", :action => "index"
  
  map.profiles '/profiles', :controller =>"profiles", :action => "index"

  map.sand_box '/sand_box', :controller => "sand_box", :action => "index"

  map.root :controller => "status_home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.connect ':action', :controller => "help"
end
