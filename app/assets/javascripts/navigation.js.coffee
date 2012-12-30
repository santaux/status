window.upload_data = (pointer, container_selector, li_selector) ->
  container = $(container_selector)
  container.animate({opacity: 0.2})
  $(li_selector).removeClass('active')
  $(pointer).parent().addClass('active')

  $.get($(pointer).attr('href'), (data) ->
    container.html(data)
    container.animate({opacity: 1})
    # Redraw graphs:
    window.graphsDraw()
  )


  return false

