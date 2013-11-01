# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

ready = ->
  $('.edit_access_level > :checkbox').change ->
    $(this).parent().submit()

  # Fancy fields
  datePickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd HH:mm")
  }

  $('#start').datetimepicker(datePickerOptions)
  $('#end').datetimepicker(datePickerOptions)
  $('#registration-start').datetimepicker(datePickerOptions)
  $('#registration-end').datetimepicker(datePickerOptions)

  # Adds Bootstrap error classes to all faulty fields
  $(".field_with_errors").parent().filter(".form-group").addClass("has-error")

  if window.location.hash
    $("a[data-toggle=tab][href="+window.location.hash+"]").tab('show')

  $("#delete-confirm").on "show.bs.modal", ->
    $submit = $(this).find(".btn-danger")
    href = $submit.attr("href")
    $submit.attr "href", href+$(this).data("id")

  $(".delete-confirm").click (e) ->
    e.preventDefault()
    $("#delete-confirm").data("id", $(this).data("id")).modal "show"


$(document).ready(ready)
$(document).on('page:load', ready)
