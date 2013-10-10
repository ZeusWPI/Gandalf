# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

ready = ->
  $('.edit_access_level > :checkbox').change ->
    console.log($(this))
    console.log($(this).parent())
    $(this).parent().submit()

$(document).ready(ready)
$(document).on('page:load', ready)
