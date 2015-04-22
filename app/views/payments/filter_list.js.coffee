filter_form = "<%= escape_javascript(render(:partial => 'filter_form')) %>"
$('#filter').html(filter_form)
$('#filter-select').change ->
  $.ajax({
    type: "POST",
    url: "<%= filter_search_payments_path %>",
    data: { acct_filter: $('#filter-select').val() },
    success:(data) ->
      return false
    error:(data) ->
      comms_error(data)
      return false
  })
comms_error = (data) ->
  alert("error")