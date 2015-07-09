module ForemanHieraLookup
  module HostsHieraLookupActions

  	extend ActiveSupport::Concern
  	included do
  		skip_before_filter :find_resource, :only => [:hiera_lookup]
  	end

  	extend Apipie::DSL::Concern

  	api :GET, "/hosts/:id/hiera_lookup", "Get hiera variable value"
    param :id, :identifier, :required => true
    param :hiera_variable, String, :required => false, :desc => "Hiera variable to lookup"

    def hiera_lookup
      @host = (Host.find(params[:id]) || Host.find_by_name(params[:id])) if Host::Managed.respond_to?(:authorized) &&
                                               Host::Managed.authorized("view_host", Host::Managed)
      render :json => @host.get_hiera_lookup_variable_value(params[:hiera_variable]) 
    end

  end
end
