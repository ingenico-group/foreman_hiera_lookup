
function load_host_hiera_lookup_popup() {
  document.getElementById("hiera_variable").focus();
  $('#hiera_variable').val('');	
  $("#hiera_variable_value").html('');
  $("#confirmation-modal #hiera_variable_value").html('');
  $("#confirmation-modal #hiera_variable_found_and_dependencies").html('');
  $("#confirmation-modal").modal('show');
  setTimeout(function() {$('#hiera_variable').focus();}, 500);
}

function get_hiera_lookup_value(){
  $("#hiera_variable_error").html('');
  $("#confirmation-modal #hiera_variable_value").html("");
  $("#confirmation-modal #hiera_variable_found_and_dependencies").html("");
	var hiera_variable_regex = /^[A-Za-z0-9.:_\-@]+$/;
	var url = $('#host_hiera_lookup_btn').attr('data-url');
  var hiera_variable = $('#hiera_variable').val()
  if (hiera_variable != 0 && url != 0 && hiera_variable_regex.test(hiera_variable)){
    $("#hiera_variable_value").html("<div class='col-md-12'><img src='/assets/spinner.gif' alt='Spinner'> Loading hiera lookup value...  </div>");
    $.ajax({
      data: {},
      type: 'get',
      url: url+ "?hiera_variable=" + hiera_variable,
      success: function(response) {
        $("#confirmation-modal #hiera_variable_value").html("")
        var resp_json = jQuery.parseJSON(response)
        // alert(JSON.stringify(response))
        if(response["error"] == null){
          $("#confirmation-modal #hiera_variable_value").html("<pre>"+response["value"]+"</pre>")
          html_report = ""
          if(response["value"] != "" || response["value"] != "nil"){
            
            for(i=0; i<response["found"].length; i++){
              html_report += "<tr><td>"+hiera_variable+"</td><td>"+response["found"][i].backend+" / "
              if(response["found"][i].url == ""){
                html_report += response["found"][i].path 
              }else{
                html_report += "<a href='"+response["found"][i].url+"' target='_blank'>"+ response["found"][i].path +"</a>"
              }
              html_report += "</td></tr>"
            }
            
          }          
          
          if(response["dependency"].length > 0){
            for(i=0; i<response["dependency"].length; i++){
              
              var dep = response["dependency"][i]
              for(var key in dep) {
                html_report += "<tr><td><a href='javascript: get_hiera_lookup_dependent_value(\""+key+"\");'>"+key+"</a></td><td>"+dep[key].backend+" / "
                if(dep[key].url == ""){
                  html_report += dep[key].path 
                }else{
                  html_report += "<a href='"+dep[key].url+"' target='_blank'>"+ dep[key].path +"</a>"
                }
                html_report += "</td></tr>"
              }              
            }
          }          
          $("#confirmation-modal #hiera_variable_found_and_dependencies").html(html_report);
        }else if(response["error"]["output"] != null){
          $("#confirmation-modal #hiera_variable_value").html("<pre>"+response["error"]["output"].replace("\n", "<br />")+"</pre>");
        }else{
          $("#hiera_variable_error").html(response["error"]["message"]);
        
        }        
      },
      error: function(jqXHR, status, error){
        $("#confirmation-modal #hiera_variable_value").html(Jed.sprintf(__("Error in loading hiera lookup: %s"), error));
        
      }
    })
  }else{
    $("#hiera_variable_error").html('Invalid input');
  }

}

function get_hiera_lookup_dependent_value(variable){
  $('#hiera_variable').val(variable);
  get_hiera_lookup_value();
}

