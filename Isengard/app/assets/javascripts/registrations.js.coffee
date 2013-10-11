# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#add-period').click ->
    $('#zone_accesses').append($('.zone_access').last().clone())
    c = Number($('#counter').val()) + 1
    $('.zone_access').last().children('.period').attr('name', 'registration[zone_accesses][' + c + '][period]')
    $('.zone_access').last().children('.zone').attr('name', 'registration[zone_accesses][' + c + '][zone]')
    $('#counter').val(c)

$(document).ready(ready)
$(document).on('page:load', ready)
