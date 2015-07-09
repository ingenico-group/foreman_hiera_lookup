# Deface::Override.new(
#       :virtual_path => "hosts/show",
#       :name => "display_hiera_lookup_form",
#       :insert_before => "table#details_table",
#       :partial  => "/foreman_hiera_lookup/hosts/hiera_lookup_form"
#     )

# Deface::Override.new(
#       :virtual_path => "hosts/show",
#       :name => "display_hiera_lookup_button",
#       :insert_after => "div#title_action",
#       :text => "\n   <a data-id='aid_hosts_hiera_lookup' class='btn btn-info'>Hiera Lookup</a>"
#     )

Deface::Override.new(
      :virtual_path => "hosts/show",
      :name => "hiera_lookup_button",
      :insert_bottom => "table#details_table tr td",
      :partial  => "/foreman_hiera_lookup/hosts/hiera_lookup_button"
      # :text => " <a title='' data-id='aid_hosts_hiera_lookup' data-url='#{hiera_lookup_host_path(@host)}' class='btn btn-default' onclick='load_host_hiera_lookup_popup(\"<%= @host %>\")' data-original-title='Lookup hiera variable value'>Hiera Lookup</a>"
    )

Deface::Override.new(
	:virtual_path => "hosts/show",
	:name => "hiera_lookup_popup",
	:insert_after => "table",
	:partial  => "/foreman_hiera_lookup/hosts/hiera_lookup_model_popup"
	)

