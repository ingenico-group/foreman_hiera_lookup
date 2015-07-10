# ForemanHieraLookup

Showing to a foreman user a value of hiera variable for a specific host

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

# Configuration

Add below content to settings.yaml file 

```yaml
:hiera_lookup:
  :secured_backend: ['PGP'] # These are the array of BACKEND values, which mask the values of variables 
  :url_templates:
    :YAML:  "http://sysgit01.lab.services.ingenico.com/puppet/puppet-hieradata/blob/#{level.gsub('environments/', '')}.yaml" # This is the template URL in the gitlab, level is the YAML file path where the variable found.  Example level=environments/dev/staging
```

You will need to restart Foreman for changes to take effect, as the `settings.yaml` is
only read at startup.

## Usage

In host details page, there is a button "Hiera Lookup" in left side under Details section. When user click on "Hiera Lookup" button one popup box will appear with input box. If we enter hiera variable and submit, It will display the value of given hiera variable for that host

# Screenshots
![Hiera Lookup button in host show page](https://raw.githubusercontent.com/ingenico-group/screenshots/master/foreman_hiera_lookup/hiera_lookup_button_in_server_details_page.png)

![Hiera Lookup popup](https://raw.githubusercontent.com/ingenico-group/screenshots/master/foreman_hiera_lookup/hiera_lookup_popup.png)


## API

Below API will return hiera value of given hiera variable on given host.

API request

```yaml
$> curl -u 'admin:changeme' -H 'accept:application/json'  'http://localhost:3000/api/hosts/:host_id/hiera_lookup' -d 'hiera_variable=variable' -X GET
```

API response

```yaml
{
  "dependency":[
    {
      "dep1":
        {
          "backend":"YAML",
          "path":"environments/dev/common",
          "url":"http://sysgit01.lab.services.ingenico.com/puppet/puppet-hieradata/blob/dev/common.yaml"
        }
    }],
  "found":[
    {
      "backend":"YAML",
      "path":"environments/dev/staging",
      "url":"http://sysgit01.lab.services.ingenico.com/puppet/puppet-hieradata/blob/dev/staging.yaml"
    }],
  "value":"specific-for-staging-with-dep1"
}

```

NOTE: This API is available only on V2

## Contributing

Fork and send a Pull Request. Thanks!

## License

GPLv3

