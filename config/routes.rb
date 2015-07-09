Rails.application.routes.draw do
  
  namespace :api, :defaults => {:format => 'json'} do
		scope "(:apiv)", :module => :v2,
		:defaults => {:apiv => 'v2'},
		:apiv => /v1|v2/,
		:constraints => ApiConstraints.new(:version => 2, :default => true) do
			constraints(:id => /[^\/]+/) do
				get 'hosts/(:id)/hiera_lookup', :to => 'hosts#hiera_lookup', :as => :hiera_lookup_host
			end
		end
	end
end
