ActionController::Routing::Routes.draw do |map|
  map.resources :clinical_trials, :only => [:index, :show]
  map.root :controller => 'clinical_trials', :action => 'index'
  map.search '/search', :controller => 'clinical_trials', :action => 'search'
  map.statistics '/statistics', :controller => 'clinical_trials', :action => 'statistics'
end
