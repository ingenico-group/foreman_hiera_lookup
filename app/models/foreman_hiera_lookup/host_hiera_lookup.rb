require "open3"
module ForemanHieraLookup
  module HostHieraLookup
    extend ActiveSupport::Concern   
    # include Open3

    HIERA_VARIABLE_REGEX = /^[A-Za-z0-9.:_\-@]+$/
    def get_hiera_lookup_variable_value(hiera_var)
      hiera_lookup_outpu = {"error" => {"message" => "Invalid input"}}
      if HIERA_VARIABLE_REGEX.match(hiera_var.to_s)
        # hiera_output = (%x[hiera #{hiera_var} environment=#{self.environment_name} #{self.parameters.map{|hp| "#{hp.name}=#{hp.value}"}.join(" ")} --yaml=/var/lib/puppet/yaml/facts/#{self.fqdn}.yaml --debug 2>&1]).split("\n")
        begin
          stdin, stdout, stderr = Open3.popen3("hiera #{hiera_var} environment=#{self.environment_name} #{self.parameters.map{|hp| "#{hp.name}=#{hp.value}"}.join(" ")} --yaml=/var/lib/puppet/yaml/facts/#{self.fqdn}.yaml --debug")
          value = stdout.read.strip()
          stderr_output = stderr.read.strip()         

          if stderr_output.split("\n").any?{|res| !res.include?("DEBUG:")}
            hiera_lookup_outpu = {"error" => {"output" => stderr_output}}
          else
            secured_backends = if SETTINGS[:hiera_lookup] and SETTINGS[:hiera_lookup][:secured_backend]
              SETTINGS[:hiera_lookup][:secured_backend].is_a?(Array) ? SETTINGS[:hiera_lookup][:secured_backend] : [SETTINGS[:hiera_lookup][:secured_backend]]
            else
              []
            end
            hiera_lookup_outpu = {}
            hiera_lookup_outpu.merge!(parse_hiera_lookup_output(stderr_output, hiera_var))
            if hiera_lookup_outpu["found"] and first_found = hiera_lookup_outpu["found"].first and secured_backends.include?(first_found["backend"])
              hiera_lookup_outpu.merge!({"value" => "[MASKED]"})
            else
              hiera_lookup_outpu.merge!({"value" => value})
            end
          end
        rescue Exception => e
          hiera_lookup_outpu = {"error" => {"message" => e.message}}
        end        
      end
      return hiera_lookup_outpu
    end


    def parse_hiera_lookup_output(hiera_output, requested_key=nil)
      found = []
      # dependency = []
      backend = nil
      dependencies = []

      for line in hiera_output.split("\n")
        match = (/Looking up (.*) in (.*) backend/).match(line)
        if match and match = match.captures and !match.empty?
          var = match[0]
          if requested_key.nil? or requested_key == var
            backend = match[1]
            next
          else
            # if !dependency.include?(var)
            #   dependency << var
            # end
            next
          end
        end
        match = (/Found (.*) in (.*)/).match(line)
        if match and match = match.captures and !match.empty?
          var = match[0]
          if requested_key.nil? or requested_key == var 
            found << {"backend" => backend, "path" => match[1], "url" => get_hiera_backend_url(backend, match[1])}
            next
          else
            dependencies << {var => {"backend" => backend, "path" => match[1], "url" => get_hiera_backend_url(backend, match[1])}}
            # if !dependency.include?(var)
            #   dependency << var
            # end
            next
          end
        end

      end
      return {
        "dependency" => dependencies.uniq,
        "found" => found.uniq
      }
    end

    def get_hiera_backend_url(backend, level)
      path = level      
      backend_url_template = if !backend.to_s.empty? and SETTINGS[:hiera_lookup] and SETTINGS[:hiera_lookup][:url_templates].is_a?(Hash)
        SETTINGS[:hiera_lookup][:url_templates][backend.to_s.to_sym]
      else
        ""
      end
      return eval("\"#{backend_url_template}\"")
    end


  end
end
