window.graphsDraw = () ->
  data_uptime = eval($('#uptime').attr('data-points'))
  $.plot $("#uptime"), [data_uptime],
    xaxis:
      mode: "time"
    yaxis:
      max: 100

  data_delay_time = eval($('#delay_time').attr('data-points'))
  $.plot $("#delay_time"), [data_delay_time],
    xaxis:
      mode: "time"
      timezone: "browser"

  data_response_time = eval($('#response_time').attr('data-points'))
  $.plot $("#response_time"), [data_response_time],
    xaxis:
      mode: "time"
      timezone: "browser"

$ ->
  window.graphsDraw()
