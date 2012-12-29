# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('ul.namespaces a').live('click', -> window.upload_data(@, '#namespace_container', 'ul.namespaces li'))
