ActionController::Routing::Routes.draw do |map|
  map.resources :clinical_trials
  map.root :controller => 'clinical_trials', :action => 'index'
  map.search '/search', :controller => 'clinical_trials', :action => 'search'
end
