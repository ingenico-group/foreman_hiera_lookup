require 'deface'
# require 'foreman_hiera_lookup'
module ForemanHieraLookup
  class Engine < ::Rails::Engine
    engine_name 'foreman_hiera_lookup'

    initializer 'foreman_hiera_lookup.register_plugin', after: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_hiera_lookup do
        requires_foreman '>= 1.4'  
        # Add permissions
        # security_block :foreman_hiera_lookup do
        #   permission :view_foreman_hiera_lookup, {:'api/v2/hosts' => [:hiera_lookup] }
        # end

        # # Add a new role called 'Discovery' if it doesn't exist
        # role "Host hiera lookup", [:view_foreman_hiera_lookup]      
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_hiera_lookup.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_hiera_lookup.configure_assets', group: :assets do
      SETTINGS[:foreman_hiera_lookup] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
        Host::Managed.send(:include, ForemanHieraLookup::HostHieraLookup)
        Api::V2::HostsController.send(:include, ForemanHieraLookup::HostsHieraLookupActions)
        Api::V1::HostsController.send(:include, ForemanHieraLookup::HostsHieraLookupActions)
    end
    
  end
end
