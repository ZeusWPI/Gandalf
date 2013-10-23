# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $("#add-registration").unbind("click");
  $("#add-registration").click (event) ->
    event.preventDefault();
    $(".registration").last().after($(".registration").last().html());

  # Adds Bootstrap error classes to all faulty fields
  $(".field_with_errors").parent().filter(".form-group").addClass("has-error");

$(document).ready(ready)
$(document).on('page:load', ready)

