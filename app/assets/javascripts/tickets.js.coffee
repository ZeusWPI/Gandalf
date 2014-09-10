# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  hideCommentFieldIfNeeded = (value) ->
    val = parseInt(value)
    if (window.ticketsWithComments && window.ticketsWithComments.indexOf(val) == -1)
      $("#ticket_comment").parent().hide();
    else
      $("#ticket_comment").parent().show();

  $("#ticket_access_levels").on 'change', ->
    hideCommentFieldIfNeeded($(this).val())

  hideCommentFieldIfNeeded($("#ticket_access_levels").val())


$(document).ready(ready)
$(document).on('page:load', ready)
